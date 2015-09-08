//
//  TT_GuidepageViewController.h
//  TTFM
//
//  Created by Yinan on 14-11-25.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TT_GuidepageViewControllerDelegate <NSObject>

// 让代理创建播放暂停按钮
- (void)createPlayButton;

@end

@interface TT_GuidepageViewController : UIViewController

@property (nonatomic,weak) id<TT_GuidepageViewControllerDelegate>delegate;

@end
