//
//  TT_DetailTableViewCell.h
//  TTFM
//
//  Created by Yinan on 14-11-19.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TT_DetailTableViewCellPalyDelegate <NSObject>

- (void)playDetailDetail:(TT_Detail *)detail;

@end

@interface TT_DetailTableViewCell : UITableViewCell

// 用于设置cell
@property (nonatomic,strong) TT_Detail *detail;

// 用于旋转播放的model
@property (nonatomic,strong) TT_Detail *detail1;
@property (nonatomic,weak) id<TT_DetailTableViewCellPalyDelegate>delegate;

@end
