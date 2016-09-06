//
//  AmazonQuery.h
//  Revel
//
//  Created by Max von Hippel on 9/1/16.
//  Copyright © 2016 Max von Hippel. All rights reserved.
//
//  This object is used to search Amazon for a product name and return results
//
//  AmazonQuery* query = [[AmazonQuery alloc] init];
//  [query searchResultArray:@"your_amazon_affiliate_id" query:@"whatever it is you want to buy"];

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class AmazonSearchResult;

@interface AmazonQuery : NSObject

//  searches for products matching the query and returns an array of AmazonSearchResult's with affiliate links
//  query is the search string, for example, spyderco
//  amazonId is the amazon affiliate id
- (NSArray*)searchResultArray:(NSString*)amazonId query:(NSString*)query;

@end
