//
//  FMResolve.m
//  ListenFM
//
//  Created by lanou3g on 14-11-5.
//
//

#import "FMResolve.h"

@implementation FMResolve

- (id)init
{
    self = [super init];
    if (self) {
       // 
       
    }
    return self;
}
- (NSString *)urlStr:(int)count
{
    
    NSMutableString * songStr = [NSMutableString stringWithFormat:@"http://douban.fm/j/mine/playlist?type=n&channel=%d&from=mainsite",count];
    return songStr;
}

//请求网络解析数据存入数组
- (void)JSONWithUrl:(NSString *)urlString andBlock:(Block)dataBlock
{
    NSURL * url = [[NSURL alloc]initWithString:urlString];
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data == nil) {
            
            UIAlertView * alert = [[UIAlertView alloc ]initWithTitle:@"提示" message:@"当前没有网络，请联网后收听" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            
            return ;
        }
        
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray * temArray = [dic objectForKey:@"song"];
        
        dataBlock(temArray);
    }];

}
//判断是否下载完
- (void)JsonData:(NSString *)str
{
    FMResolve * json = [[FMResolve alloc]init];
    [json JSONWithUrl:str andBlock:^(id param) {
        if ([_delegate respondsToSelector:@selector(jsonDataDidFinishLoad:)]) {
            [_delegate jsonDataDidFinishLoad:param];
        }
    }];

}

@end
