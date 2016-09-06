//
//  AmazonSearchResult.h
//  Revel
//
//  Created by Max von Hippel on 9/1/16.
//  Copyright © 2016 Max von Hippel. All rights reserved.
//
//  This object represents an instance of an individual Amazon search result

#import <Foundation/Foundation.h>

@interface AmazonSearchResult : NSObject

@property (nonatomic, retain) NSURL* productUrl;
@property (nonatomic, retain) NSURL* productImageUrl;
@property (nonatomic, retain) NSString* productName;

@end
