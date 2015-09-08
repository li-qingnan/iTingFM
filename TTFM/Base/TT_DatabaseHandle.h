//
//  TT_DatabaseHandle.h
//  TTFM
//
//  Created by Yinan on 14-11-18.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TT_Channel.h"

@interface TT_DatabaseHandle : NSObject

+ (TT_DatabaseHandle *)shareInstance;


#pragma mark - ******* 频道页操作 *******

//创建表
- (void)creatTable;

// 增加频道页表数据
- (void)insertCategory:(NSString *)category tnameArr:(NSArray *)tnameArray pictureArray:(NSArray *)pictureArray;

//查询频道页操作
- (NSArray *)getAllChannelCategory:(NSString *)category;

#pragma mark - ******* 详情列表页操作 *******

//创建表
- (void)creatTableDetailList;

// 增加详情列表页数据
- (void)insertTagname:(NSString *)tagname detailListArr:(NSArray *)detailListArr;

//查询详情列表页操作
- (NSArray *)getAllDetailListTagname:(NSString *)tagname;


#pragma mark - ******* 详情页操作 *******

//创建表
- (void)creatTableDetail;

// 增加详情列表页数据
- (void)insertID:(NSString *)ID dic:(NSDictionary *)dic detailArr:(NSArray *)detailArr;

//查询详情列表页操作
- (NSArray *)getAllDetailListID:(NSString *)ID;


#pragma mark - ******* 试听记录操作 *******  

//创建表
- (void)creatTableListon;

// 增加试听记录数据
- (void)insertID:(NSString *)ID playUrl:(NSString *)playUrl title:(NSString *)title picUrl:(NSString *)picUrl;

// 根据id查询是否存在
- (BOOL)selectListonID:(NSString *)ID;

// 查询试听记录所有元素
- (NSMutableArray *)selectAllListon;



@end
