//
//  TT_SongModel.h
//  TTFM
//
//  Created by Yinan on 14-11-20.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TT_SongModel : NSObject

//专辑
@property (nonatomic,retain)NSString *album;
//专辑名
@property (nonatomic,retain)NSString *albumtitle;
//艺术家
@property (nonatomic,retain)NSString *artist;
//公司
@property (nonatomic,retain)NSString *company;
//图片
@property (nonatomic,retain)NSString *picture;
//发布时间
@property (nonatomic,retain)NSString *public_time ;
//标题
@property (nonatomic,retain)NSString *title;
//网址
@property (nonatomic,retain)NSString *url;

@end
