//
//  TT_TableViewController.h
//  TTFM
//
//  Created by Yinan on 14-11-18.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TT_TableViewController : UITableViewController

// 接收上一页传来的参数
@property (nonatomic,strong) NSString *category_name;
@property (nonatomic,strong) NSString *tag_name;

@end
