//
//  AmazonSearchResult.m
//  Revel
//
//  Created by Max von Hippel on 9/1/16.
//  Copyright © 2016 Max von Hippel. All rights reserved.
//

#import "AmazonSearchResult.h"

@implementation AmazonSearchResult
@synthesize productUrl, productName, productImageUrl;

// ----------------------------------------------- coder methods ------------------------------------------------------

// encode an object to memory
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:productUrl forKey:@"productUrl"];
    [coder encodeObject:productName forKey:@"productName"];
    [coder encodeObject:productImageUrl forKey:@"productImageUrl"];
}

// decode the object from memory
- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    self.productUrl = [coder decodeObjectForKey:@"productUrl"];
    self.productName = [coder decodeObjectForKey:@"productName"];
    self.productImageUrl = [coder decodeObjectForKey:@"productImageUrl"];
    return self;
}

@end
