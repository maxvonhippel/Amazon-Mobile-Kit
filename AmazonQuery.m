//
//  AmazonQuery.m
//  Revel
//
//  Created by Max von Hippel on 9/1/16.
//  Copyright © 2016 Max von Hippel. All rights reserved.
//

#import "AmazonQuery.h"
#import "AmazonSearchResult.h"

@implementation AmazonQuery

- (NSArray*)searchResultArray:(NSString*)amazonId query:(NSString*)query {

    //  do we have valid arguments?
    if (!amazonId || !query || [amazonId length] <= 0 || [query length] <= 0)
        return NULL;
    //  can we connect to amazon?
    NSURL* searchUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.amazon.com/s/ref=nb_sb_noss_2?url=search-alias%%3Daps&field-keywords=%@", [query stringByReplacingOccurrencesOfString:@" " withString:@"+"]]];
    //  get the html of the amazon search results page
    NSError* err = nil;
    NSString* html = [NSString stringWithContentsOfURL:searchUrl encoding:NSUTF8StringEncoding error:&err];
    if (!html) {
        
        NSLog(@"no html found");
        return NULL;
    }
    
    //  we need to make an array to return
    NSMutableArray* returnArray = [[NSMutableArray alloc] init];
    //  next, we need to populate that array
    NSError* error = NULL;
    //  we use a regex to find objects for sale on the results webpage from the html we just found
    NSRegularExpression* regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"title=\"(.*?)\" href=\"(.*?)\">"
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    //  next we iterate over each object for sale and add it to our array to return
    for (NSTextCheckingResult* result in [regex matchesInString:html options:0 range:NSMakeRange(0, [html length])]) {
        
        //  this is the pertinant html for us to scan for this particular object for sale
        NSString* resultString = [html substringWithRange:result.range];
        //  we need to confirm that it is actually formatted correctly before we continue
        if ([resultString containsString:@"title=\""] && [resultString containsString:@"\" href=\""]) {
            
            //  create the individual search result
            AmazonSearchResult* result = [[AmazonSearchResult alloc] init];
            //  get the locations within the substring of the title and link
            NSRange startTitle = [resultString rangeOfString:@"title=\""];
            NSRange endTitle = [resultString rangeOfString:@"\" href=\""];
            
            //  make sure this substring is formatted correctly before parsing it
            if (startTitle.location + startTitle.length < endTitle.location &&
                endTitle.location + endTitle.length < [resultString length] - 2) {
                
                //  find the product name between the end of the ...title=" and the start of the " href=..."
                result.productName = [resultString substringWithRange:NSMakeRange(startTitle.location + startTitle.length, endTitle.location - startTitle.location - startTitle.length)];
                //  find the product url between the end of the " href=" and the start of the ">...
                result.productUrl = [NSURL URLWithString:[resultString substringWithRange:NSMakeRange(endTitle.location + endTitle.length, [resultString length] - 2 - endTitle.location - endTitle.length)]];
                
                //  finally, we need to find the image for the result
                NSError* productError = nil;
                NSString* productHtml = [NSString stringWithContentsOfURL:result.productUrl encoding:NSUTF8StringEncoding error:&productError];
                if (productHtml) {
                    
                    //  next, we make the regex to scan the individual product page
                    NSError* prodError = NULL;
                    NSRegularExpression* prodRegex = [NSRegularExpression regularExpressionWithPattern:@"<div class=\"prodImage\"><(.*?)><img src=\"(.*?)\"" options:NSRegularExpressionCaseInsensitive error:&prodError];
                    //  ok so now we need to get the image source out of the above regex
                    for (NSTextCheckingResult* prodResult in [prodRegex matchesInString:productHtml options:0 range:NSMakeRange(0, [productHtml length])]) {
                        
                        //  if we have a result, we need to make sure that this thing is formatted correctly
                        NSString* prodResultString = [productHtml substringWithRange:prodResult.range];
                        if (prodResultString && [prodResultString containsString:@"img src=\""]) {
                            
                            NSRange startImg = [prodResultString rangeOfString:@"img src=\""];
                            if (startImg.location + startImg.length < [prodResultString length] - 1) {
                                
                                //  we are in the clear.  grab the link!
                                result.productImageUrl = [NSURL URLWithString:[prodResultString substringWithRange:NSMakeRange(startImg.location + startImg.length, [prodResultString length] - 1 - startImg.location - startImg.length)]];
                            }
                        }
                        //  we only want one image, so we now break
                        break;
                    }
                }
            }
            
            //  if we have an amazon id to use, then we turn the normal link into an affiliate link
            if (amazonId) {
                    //  take the original link which looks like this:
                        //  http://www.amazon.com/gp/product/B00005JG32/ref=cm_lm_fullview_prod_3/102-2173641-6432913?%5Fencoding=UTF8&v=glance
                    //  and we want it to look like this:
                        //  http://www.amazon.com/[something]/[something]/[something]/[some code]/[amazon id]
                //  split by "/"
                NSArray *elements = [result.productUrl.absoluteString componentsSeparatedByString: @"/"];
                //  grab the subarray
                if ([elements count] < 6)
                    break;
                NSArray *subelements = [elements subarrayWithRange: NSMakeRange(0, 6)];
                //  concat by "/" again
                NSString *output = [subelements componentsJoinedByString:@"/"];
                //  create the final url
                NSURL *affiliateLink = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", output, amazonId]];
                //  set it to be the new product url
                result.productUrl = affiliateLink;
                NSLog(@"affiliate link produced: %@\n", affiliateLink.absoluteString);
            }
            
            //  finally, we need to add this particular product (result) to a list of found products to be presented
            [returnArray addObject:result];
        }
        
    }
    
    //  return the final array!
    return [NSArray arrayWithArray:returnArray];
    
}

@end
