//
//  TT_ListenViewController.h
//  TTFM
//
//  Created by Yinan on 14-11-17.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGLDropDownMenu.h"
#import "FMResolve.h"


@protocol TT_ListenViewControllerDelegate <NSObject>

- (void)backgroundNextAndPrevious;

@end


@interface TT_ListenViewController : UIViewController<IGLDropDownMenuDelegate,JSONDataDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,assign) id<TT_ListenViewControllerDelegate>delegate;

// 播放器
@property(nonatomic,retain)MPMoviePlayerViewController *playFM;

// 解析完的数据存入数组
@property (nonatomic,retain)NSMutableArray * array;
// 选项卡
@property (nonatomic,strong)IGLDropDownMenu * dropDownMenu;

// 背景图
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
// 艺术家
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
// 歌曲名
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
// 播放暂停
@property (weak, nonatomic) IBOutlet UIButton *playAndPauseBtn;
// 刷新
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;

// collectionView
@property (retain,nonatomic)UICollectionView * collectionView;

// 当前所在类型
@property (assign,nonatomic)int prsentIndex;

@property (assign,nonatomic)int prsentStateIndex;

@property (nonatomic,assign)BOOL playAndPause;

// 播放暂停按钮响应方法
- (IBAction)playAndPause:(id)sender;

// 刷新响应方法
- (IBAction)refreshBtn:(id)sender;




@end
