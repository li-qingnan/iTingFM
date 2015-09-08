//
//  TT_GaussBlur.h
//  TTFM
//
//  Created by 李一楠 on 14/11/21.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TT_GaussBlur : NSObject

- (id)init;

-(UIImage*)getBlurImage:(UIImage*)image;

@end
