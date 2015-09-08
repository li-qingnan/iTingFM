//
//  UIButton+NMCategory.h
//  DragButtonDemo
//
//  Created by 李一楠 on 14-7-5.
//  Copyright (c) 2014年 Liyinan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (NMCategory)

@property(nonatomic,assign,getter = isDragEnable)   BOOL dragEnable;
@property(nonatomic,assign,getter = isAdsorbEnable) BOOL adsorbEnable;

@end
