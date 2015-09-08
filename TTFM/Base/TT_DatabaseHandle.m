//
//  TT_DatabaseHandle.m
//  TTFM
//
//  Created by Yinan on 14-11-18.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import "TT_DatabaseHandle.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMResultSet.h"
#import <sqlite3.h>




@interface TT_DatabaseHandle ()

// 频道
@property (nonatomic,strong) FMDatabase *db;
// 详情列表
@property (nonatomic,strong) FMDatabase *db1;
// 详情页
@property (nonatomic,strong) FMDatabase *db2;
// 试听记录
@property (nonatomic,strong) FMDatabase *db3;

@end

@implementation TT_DatabaseHandle

static TT_DatabaseHandle *handle = nil;

+ (TT_DatabaseHandle *)shareInstance
{
    if (handle == nil) {
        handle = [[TT_DatabaseHandle alloc] init];
        
        [handle databaseFilePath];
        [handle creatDatabase];
    }
    return handle;
}


#pragma mark - ******* 频道页操作 *******

//路径
- (NSString *)databaseFilePath
{
    NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * dbPath = [documentPath stringByAppendingPathComponent:@"Channel.sqlite"];
    return dbPath;
}

//创建数据库单例
- (void)creatDatabase
{
    self.db = [FMDatabase databaseWithPath:[self databaseFilePath]];
}

//创建表
- (void)creatTable
{
    //先判断数据库是否存在，如果不存在，创建数据库
    if (!self.db){
        [self creatDatabase];
    }
    
    //判断数据库是否已经打开，如果没有打开，提示失败
    if (![self.db open]) {

    }
    
    //为数据库设置缓存，提高查询效率
    [self.db setShouldCacheStatements:YES];
    
    //判断数据库中是否已经存在这个表，如果不存在则创建该表
    if(![self.db tableExists:@"channel"])
    {

        [self.db executeUpdate:@"CREATE TABLE channel (category TEXT,tname BLOB,picture BLOB)"];

	}
}



//增加频道页表数据
- (void)insertCategory:(NSString *)category tnameArr:(NSArray *)tnameArray pictureArray:(NSArray *)pictureArray;
{
    //先判断数据库是否存在，如果不存在，创建数据库
    if (!self.db){
        [self creatDatabase];
    }
    
    //判断数据库是否已经打开，如果没有打开，提示失败
    if (![self.db open]) {

    }
    
    //为数据库设置缓存，提高查询效率
    [self.db setShouldCacheStatements:YES];
    
    //判断数据库中是否已经存在这个表，如果不存在则创建该表
    if(![self.db tableExists:@"channel"])
    {
        [self creatTable];
	}
    
    //先在表中查询有没有相同的元素，如果有，做修改操作
	FMResultSet *rs = [self.db executeQuery:@"select * from channel where category = ?",category];
	if([rs next])
	{

        return;
	}
	//向数据库中插入一条数据
	else{
        // 将数组归档
        NSMutableData *data1 = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver1 = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data1];
        [archiver1 encodeObject:tnameArray forKey:@"tname"];
        [archiver1 finishEncoding];
        
        NSMutableData *data2 = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver2 = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data2];
        [archiver2 encodeObject:pictureArray forKey:@"picture"];
        [archiver2 finishEncoding];
        
        [self.db executeUpdate:@"INSERT INTO channel (category,tname,picture) VALUES (?,?,?)",category,data1,data2];
	}
    
}


//查询操作
- (NSArray *)getAllChannelCategory:(NSString *)category
{
    //先判断数据库是否存在，如果不存在，创建数据库
    if (!self.db){
        [self creatDatabase];
    }
    
    //判断数据库是否已经打开，如果没有打开，提示失败
    if (![self.db open]) {

    }
    
    //为数据库设置缓存，提高查询效率
    [self.db setShouldCacheStatements:YES];
    
    if(![self.db tableExists:@"channel"])
    {
        return nil;
	}
    
    //定义一个可变数组，用来存放查询的结果，返回给调用者
    NSMutableArray *array = [[NSMutableArray alloc] init];
    //定义一个结果集，存放查询的数据

    FMResultSet *rs = [self.db executeQuery:@"select * from channel where category = ?",category];
    //判断结果集中是否有数据，如果有则取出数据
    while ([rs next]) {
        
        // 反归档取出数据  并加到数组里返回
        NSData *data1 = [rs dataForColumn:@"tname"];
        NSKeyedUnarchiver *unarchiver1 = [[NSKeyedUnarchiver alloc] initForReadingWithData:data1];
        NSArray *array1 = [[NSArray alloc] init];
        array1 = [unarchiver1 decodeObjectForKey:@"tname"];
        [array addObject:array1];
        
        NSData *data2 = [rs dataForColumn:@"picture"];
        NSKeyedUnarchiver *unarchiver2 = [[NSKeyedUnarchiver alloc] initForReadingWithData:data2];
        NSArray *array2 = [[NSArray alloc] init];
        array2 = [unarchiver2 decodeObjectForKey:@"picture"];
        [array addObject:array2];
    }
    
    
	return array;
    
}


#pragma mark - ******* 详情列表页操作 *******



//路径
- (NSString *)databaseFilePathDetailList
{
    NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];

    
    NSString * dbPath = [documentPath stringByAppendingPathComponent:@"DetailList.sqlite"];
    return dbPath;
}

//创建数据库单例
- (void)creatDatabaseDetailList
{
    self.db1 = [FMDatabase databaseWithPath:[self databaseFilePathDetailList]];
}

//创建表
- (void)creatTableDetailList
{
    //先判断数据库是否存在，如果不存在，创建数据库
    if (!self.db1){
        [self creatDatabaseDetailList];
    }
    
    //判断数据库是否已经打开，如果没有打开，提示失败
    if (![self.db1 open]) {

    }
    
    //为数据库设置缓存，提高查询效率
    [self.db1 setShouldCacheStatements:YES];
    
    //判断数据库中是否已经存在这个表，如果不存在则创建该表

    
    if (![self.db1 tableExists:@"DetailList"]) {
        
        [self.db1 executeUpdate:@"CREATE TABLE DetailList (tagname TEXT,detailList BLOB)"];
    }
    
    
}


// 增加详情列表页数据
- (void)insertTagname:(NSString *)tagname detailListArr:(NSArray *)detailListArr
{
    //先判断数据库是否存在，如果不存在，创建数据库
    if (!self.db1){
        [self creatDatabaseDetailList];
    }
    
    //判断数据库是否已经打开，如果没有打开，提示失败
    if (![self.db1 open]) {

    }
    
    //为数据库设置缓存，提高查询效率
    [self.db1 setShouldCacheStatements:YES];
    
    //判断数据库中是否已经存在这个表，如果不存在则创建该表
    if(![self.db1 tableExists:@"DetailList"])
    {
        [self creatTableDetailList];
	}
    
    //先在表中查询有没有相同的元素，如果有，做修改操作
	FMResultSet *rs = [self.db1 executeQuery:@"select * from DetailList where tagname = ?",tagname];
	if([rs next])
	{

        return;
	}
    //向数据库中插入一条数据
	else{
        
        // 将数组归档
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:detailListArr forKey:@"detailList"];
        [archiver finishEncoding];
        
        [self.db1 executeUpdate:@"INSERT INTO DetailList (tagname,detailList) VALUES (?,?)",tagname,data];
	}

}


//查询详情列表页操作
- (NSArray *)getAllDetailListTagname:(NSString *)tagname
{

    //先判断数据库是否存在，如果不存在，创建数据库
    if (!self.db1){
        [self creatDatabaseDetailList];
    }
    
    //判断数据库是否已经打开，如果没有打开，提示失败
    if (![self.db1 open]) {

    }
    
    //为数据库设置缓存，提高查询效率
    [self.db1 setShouldCacheStatements:YES];
    
    //判断数据库中是否已经存在这个表，如果不存在则创建该表
    if(![self.db1 tableExists:@"DetailList"])
    {
        return nil;
	}
    
    //定义一个可变数组，用来存放查询的结果，返回给调用者
    NSMutableArray *array = [[NSMutableArray alloc] init];
    //定义一个结果集，存放查询的数据

    FMResultSet *rs = [self.db executeQuery:@"select * from DetailList where tagname = ?",tagname];
    //判断结果集中是否有数据，如果有则取出数据
    while ([rs next]) {
        
        // 反归档取出数据  并加到数组里返回
        NSData *data = [rs dataForColumn:@"detailList"];
        NSKeyedUnarchiver *unarchiver1 = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        array = [unarchiver1 decodeObjectForKey:@"detailList"];
    }
    
    
	return array;

}

#pragma mark - ******* 详情页操作 *******

//路径
- (NSString *)databaseFilePathDetail
{
    NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];

    
    NSString * dbPath = [documentPath stringByAppendingPathComponent:@"Detail.sqlite"];
    return dbPath;
}

//创建数据库单例
- (void)creatDatabaseDetail
{
    self.db2 = [FMDatabase databaseWithPath:[self databaseFilePathDetail]];
}


//创建表
- (void)creatTableDetail
{
    //先判断数据库是否存在，如果不存在，创建数据库
    if (!self.db2){
        [self creatDatabaseDetail];
    }
    
    //判断数据库是否已经打开，如果没有打开，提示失败
    if (![self.db2 open]) {

    }
    
    //为数据库设置缓存，提高查询效率
    [self.db2 setShouldCacheStatements:YES];
    
    //判断数据库中是否已经存在这个表，如果不存在则创建该表
    
    
    if (![self.db2 tableExists:@"Detail"]) {
        
        [self.db2 executeUpdate:@"CREATE TABLE Detail (ID TEXT,dic BLOB,detail BLOB)"];
    }
}

// 增加详情列表页数据
- (void)insertID:(NSString *)ID dic:(NSDictionary *)dic detailArr:(NSArray *)detailArr
{

    //先判断数据库是否存在，如果不存在，创建数据库
    if (!self.db2){
        [self creatDatabaseDetail];
    }
    
    //判断数据库是否已经打开，如果没有打开，提示失败
    if (![self.db2 open]) {

    }
    
    //为数据库设置缓存，提高查询效率
    [self.db2 setShouldCacheStatements:YES];
    
    //判断数据库中是否已经存在这个表，如果不存在则创建该表
    if(![self.db2 tableExists:@"Detail"])
    {
        [self creatTableDetail];
	}
    
    //先在表中查询有没有相同的元素，如果有，做修改操作
	FMResultSet *rs = [self.db2 executeQuery:@"select * from Detail where ID = ?",ID];
	if([rs next])
	{

        return;
	}
	//向数据库中插入一条数据
	else{
        // 将数据归档
        NSMutableData *data1 = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver1 = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data1];
        [archiver1 encodeObject:dic forKey:@"dic"];
        [archiver1 finishEncoding];
        
        NSMutableData *data2 = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver2 = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data2];
        [archiver2 encodeObject:detailArr forKey:@"detail"];
        [archiver2 finishEncoding];
        
        [self.db2 executeUpdate:@"INSERT INTO Detail (ID,dic,detail) VALUES (?,?,?)",ID,data1,data2];
	}

}

//查询详情列表页操作
- (NSArray *)getAllDetailListID:(NSString *)ID
{
    //先判断数据库是否存在，如果不存在，创建数据库
    if (!self.db2){
        [self creatDatabaseDetail];
    }
    
    //判断数据库是否已经打开，如果没有打开，提示失败
    if (![self.db2 open]) {

    }
    
    //为数据库设置缓存，提高查询效率
    [self.db2 setShouldCacheStatements:YES];
    
    //判断数据库中是否已经存在这个表，如果不存在则创建该表
    if(![self.db2 tableExists:@"Detail"])
    {
        return nil;
	}
    
    //定义一个可变数组，用来存放查询的结果，返回给调用者
    NSMutableArray *array = [[NSMutableArray alloc] init];
    //定义一个结果集，存放查询的数据
    
    FMResultSet *rs = [self.db2 executeQuery:@"select * from Detail where ID = ?",ID];
    //判断结果集中是否有数据，如果有则取出数据
    while ([rs next]) {
        
        // 反归档取出数据  并加到数组里返回
        NSData *data1 = [rs dataForColumn:@"dic"];
        NSKeyedUnarchiver *unarchiver1 = [[NSKeyedUnarchiver alloc] initForReadingWithData:data1];
        NSDictionary *dic = [unarchiver1 decodeObjectForKey:@"dic"];
        [array addObject:dic];
        
        NSData *data2 = [rs dataForColumn:@"detail"];
        NSKeyedUnarchiver *unarchiver2 = [[NSKeyedUnarchiver alloc] initForReadingWithData:data2];
        NSArray *arr = [unarchiver2 decodeObjectForKey:@"detail"];
        [array addObject:arr];
    }
    
    
	return array;
    
    return nil;
}


#pragma mark - ******* 试听记录操作 *******


//路径
- (NSString *)databaseFilePathListon
{
    NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];

    
    NSString * dbPath = [documentPath stringByAppendingPathComponent:@"Liston.sqlite"];
    return dbPath;
}

//创建数据库单例
- (void)creatDatabaseListon
{
    self.db3 = [FMDatabase databaseWithPath:[self databaseFilePathListon]];
}

//创建表
- (void)creatTableListon
{
    //先判断数据库是否存在，如果不存在，创建数据库
    if (!self.db3){
        [self creatDatabaseListon];
    }
    
    //判断数据库是否已经打开，如果没有打开，提示失败
    if (![self.db3 open]) {

    }
    
    //为数据库设置缓存，提高查询效率
    [self.db3 setShouldCacheStatements:YES];
    
    //判断数据库中是否已经存在这个表，如果不存在则创建该表
    
    
    if (![self.db3 tableExists:@"Liston"]) {
        
        [self.db3 executeUpdate:@"CREATE TABLE Liston (ID TEXT,playUrl TEXT,title TEXT,picUrl TEXT)"];
    }

}

// 增加试听记录数据
- (void)insertID:(NSString *)ID playUrl:(NSString *)playUrl title:(NSString *)title picUrl:(NSString *)picUrl
{

    //先判断数据库是否存在，如果不存在，创建数据库
    if (!self.db3){
        [self creatDatabaseListon];
    }
    
    //判断数据库是否已经打开，如果没有打开，提示失败
    if (![self.db3 open]) {

    }
    
    //为数据库设置缓存，提高查询效率
    [self.db3 setShouldCacheStatements:YES];
    
    //判断数据库中是否已经存在这个表，如果不存在则创建该表
    if(![self.db3 tableExists:@"Liston"])
    {
        [self creatTableListon];
	}
    
    //先在表中查询有没有相同的元素，如果有，做修改操作
	FMResultSet *rs = [self.db2 executeQuery:@"select * from Liston where ID = ?",ID];
	if([rs next])
	{

        return;
	}
	//向数据库中插入一条数据
	else{

        
        [self.db3 executeUpdate:@"INSERT INTO Liston (ID,playUrl,title,picUrl) VALUES (?,?,?,?)",ID,playUrl,title,picUrl];
	}

}

//查询详情列表页操作
- (BOOL)selectListonID:(NSString *)ID
{
    //先判断数据库是否存在，如果不存在，创建数据库
    if (!self.db3){
        [self creatDatabaseListon];
    }
    
    //判断数据库是否已经打开，如果没有打开，提示失败
    if (![self.db3 open]) {

    }
    
    //为数据库设置缓存，提高查询效率
    [self.db3 setShouldCacheStatements:YES];
    
    //判断数据库中是否已经存在这个表，如果不存在则创建该表
    if(![self.db3 tableExists:@"Liston"])
    {
        
	}
    
    //定义一个结果集，存放查询的数据
    
    FMResultSet *rs = [self.db3 executeQuery:@"select * from Liston where ID = ?",ID];
    //判断结果集中是否有数据，如果有则取出数据
    while ([rs next]) {
        
        return YES;
        
    }
 
	return NO;
}

// 查询试听记录所有元素
- (NSMutableArray *)selectAllListon
{

    //先判断数据库是否存在，如果不存在，创建数据库
    if (!self.db3){
        [self creatDatabaseListon];
    }
    
    //判断数据库是否已经打开，如果没有打开，提示失败
    if (![self.db3 open]) {

    }
    
    //为数据库设置缓存，提高查询效率
    [self.db3 setShouldCacheStatements:YES];
    
    //判断数据库中是否已经存在这个表，如果不存在则创建该表
    if(![self.db3 tableExists:@"Liston"])
    {
        return nil;
	}
    
    //定义一个可变数组，用来存放查询的结果，返回给调用者
    NSMutableArray *array = [[NSMutableArray alloc] init];
    //定义一个结果集，存放查询的数据
    
    FMResultSet *rs = [self.db3 executeQuery:@"select ID,playUrl,title,picUrl from Liston"];
    //判断结果集中是否有数据，如果有则取出数据
    while ([rs next]) {
        NSString *ID = [rs stringForColumn:@"ID"];
        NSString *playUrl = [rs stringForColumn:@"playUrl"];
        NSString *title = [rs stringForColumn:@"title"];
        NSString *picUrl = [rs stringForColumn:@"picUrl"];
        
        TT_Detail *detail = [[TT_Detail alloc] init];
        detail.ID = (NSNumber *)ID;
        detail.playUrl64 = playUrl;
        detail.title = title;
        detail.coverLarge = picUrl;
        [array addObject:detail];
    }
    
	return array;
   
}



@end
