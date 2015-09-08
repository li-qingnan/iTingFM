//
//  TT_Channel.h
//  TTFM
//
//  Created by Yinan on 14-11-17.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TT_Channel : NSObject

@property (nonatomic,strong) NSNumber *ID; // 标签id
@property (nonatomic,strong) NSString *name;// 标签英文名
@property (nonatomic,strong) NSString *title;// 标签名
@property (nonatomic,strong) NSString *coverPath;// 图片url
@property (nonatomic,strong) NSNumber *orderNum;// 标签索引位置

@property (nonatomic,strong) NSString *tname;// 频道列表名
@property (nonatomic,strong) NSString *cover_path;// 图片url

@end
