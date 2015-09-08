//
//  TT_Detail.h
//  TTFM
//
//  Created by Yinan on 14-11-18.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TT_Detail : NSObject<NSCoding>

// TABLEVIEW 页面
@property (nonatomic,strong) NSNumber *ID;
@property (nonatomic,strong) NSString *title;// 详情页面也用
@property (nonatomic,strong) NSString *albumCoverUrl290;

// 详情页面
@property (nonatomic,strong) NSNumber *trackId;// id
@property (nonatomic,strong) NSString *tags;// 关键字
@property (nonatomic,strong) NSString *coverLarge;// 图片url
@property (nonatomic,strong) NSString *intro;// 简介
@property (nonatomic,strong) NSNumber *duration;// 持续时间 秒
@property (nonatomic,strong) NSNumber *playtimes;// 播放次数
@property (nonatomic,strong) NSNumber *likes;// 喜欢人数
@property (nonatomic,strong) NSNumber *comments;// 评论

@property (nonatomic,strong) NSString *playUrl64;
@property (nonatomic,strong) NSString *playUrl32;

@end
