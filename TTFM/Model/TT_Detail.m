//
//  TT_Detail.m
//  TTFM
//
//  Created by Yinan on 14-11-18.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import "TT_Detail.h"
#import "NSObject+NSCoding.h"

@implementation TT_Detail

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

//归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self autoEncodeWithCoder:aCoder];
    
}

//反归档
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        
        [self autoDecode:aDecoder];
 }
    
    return self;
}

@end
