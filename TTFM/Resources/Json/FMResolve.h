//
//  FMResolve.h
//  ListenFM
//
//  Created by lanou3g on 14-11-5.
//
//

#import <Foundation/Foundation.h>

typedef void (^Block)(id param);
@protocol JSONDataDelegate <NSObject>

- (void)jsonDataDidFinishLoad:(NSMutableArray *)array;

@end

@interface FMResolve : NSObject


- (id)init;

- (NSString *)urlStr:(int)count;

//请求网络解析数据存入数组
- (void)JSONWithUrl:(NSString *)urlString andBlock:(Block)dataBlock;

@property(nonatomic,assign)id<JSONDataDelegate>delegate;
- (void)JsonData:(NSString *)str;

@end
