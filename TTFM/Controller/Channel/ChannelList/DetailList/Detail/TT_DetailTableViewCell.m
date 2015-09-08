//
//  TT_DetailTableViewCell.m
//  TTFM
//
//  Created by Yinan on 14-11-19.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import "TT_DetailTableViewCell.h"
#import "JingRoundView.h"

@interface TT_DetailTableViewCell()<JingRoundViewDelegate>

@property (nonatomic,strong) UIImageView *coverView;// 封面图片

@property (nonatomic,strong) UIImageView *playtimesView;// 播放次数
@property (nonatomic,strong) UIImageView *likesView;// 喜欢人数

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *playtimesLabel;
@property (nonatomic,strong) UILabel *likesLabel;
@property (nonatomic,strong) UILabel *durationLabel;


@property (nonatomic,strong) JingRoundView *roundView;
@property (nonatomic,strong) NSURL *url;

@end

@implementation TT_DetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setupSubviews];
        //self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setupSubviews
{
    // 封面
    //self.coverView = [[UIImageView alloc] initWithFrame:CGRectMake(205, 10, 110, 130)];
    //[self.contentView addSubview:self.coverView];
    self.coverView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];

    // 旋转播放暂停
    self.roundView = [[JingRoundView alloc] initWithFrame:CGRectMake(200, 10, 120, 120)];
    self.roundView.delegate = self;
    self.roundView.rotationDuration = 7.0;
    self.roundView.roundImage = [UIImage imageNamed:@"lv"];
    [self.contentView addSubview:self.roundView];
    
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 180, 50)];
    self.titleLabel.numberOfLines = 0;
    //self.titleLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.titleLabel];

    
    // 播放次数
    self.playtimesView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 110, 20, 20)];
    self.playtimesView.image = [UIImage imageNamed:@"playtime.png"];
    [self.contentView addSubview:self.playtimesView];
    self.playtimesLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 110, 100, 20)];
    //self.playtimesLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.playtimesLabel];
    
    // 喜欢人数
    self.likesView = [[UIImageView alloc] initWithFrame:CGRectMake(120, 110, 20, 20)];
    self.likesView.image = [UIImage imageNamed:@"like1.png"];
    [self.contentView addSubview:self.likesView];
    self.likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, 110, 80, 20)];
    //self.likesLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.likesLabel];
    
}

- (void)setDetail:(TT_Detail *)detail
{
 
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:detail.coverLarge] placeholderImage:[UIImage imageNamed:@"lv.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cacheType = SDImageCacheTypeDisk;
        self.coverView.image = image;
        self.roundView.roundImage = self.coverView.image;
    }];
    

    self.titleLabel.text = detail.title;
    self.playtimesLabel.text = [NSString stringWithFormat:@"%@",detail.playtimes];
    self.likesLabel.text = [NSString stringWithFormat:@"%@",detail.likes];
    // 用于旋转播放的model
    self.detail1 = detail;
}

- (void)playStatuUpdate:(BOOL)playState
{
    
    Reachability * reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([reachability currentReachabilityStatus] == NotReachable) {
        UIAlertView * alert = [[UIAlertView alloc ]initWithTitle:@"提示" message:@"当前没有网络，请联网后收听" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }else{
        
        //显示选中的数据
        [self.delegate playDetailDetail:self.detail1];
    }

    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
