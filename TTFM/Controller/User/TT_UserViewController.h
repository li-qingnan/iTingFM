//
//  TT_UserViewController.h
//  TTFM
//
//  Created by 李一楠 on 14/11/22.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TT_ListonTableViewController.h"

@interface TT_UserViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,TT_ListonTableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

//@property (strong, nonatomic) IBOutlet UITableView *settingTableView;
@property (strong, nonatomic) IBOutlet UITableView *settingTableView;

@property (weak, nonatomic) IBOutlet UILabel *about;

@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end
