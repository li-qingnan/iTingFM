//
//  TT_ListonTableViewController.h
//  TTFM
//
//  Created by 李一楠 on 14/11/22.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TT_ListonTableViewControllerDelegate <NSObject>

- (void)backArrayCount:(NSInteger)count;

@end

@interface TT_ListonTableViewController : UITableViewController

@property (nonatomic,weak) id<TT_ListonTableViewControllerDelegate>delegate;

// 播放器
@property(nonatomic,retain) MPMoviePlayerViewController *playFM;



@end
