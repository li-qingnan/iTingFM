//
//  TT_Channel.m
//  TTFM
//
//  Created by Yinan on 14-11-17.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import "TT_Channel.h"

@implementation TT_Channel


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

@end
