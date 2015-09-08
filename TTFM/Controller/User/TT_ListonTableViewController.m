//
//  TT_ListonTableViewController.m
//  TTFM
//
//  Created by 李一楠 on 14/11/22.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import "TT_ListonTableViewController.h"

@interface TT_ListonTableViewController ()
// 存放试听记录
@property (nonatomic,strong) NSArray *array;

@property (nonatomic,strong) UIImageView *imageView;
@end

@implementation TT_ListonTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.array = [[NSArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBackgroundImage];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationItem.title = @"试听记录";
    
    self.array = [[TT_DatabaseHandle shareInstance] selectAllListon];
    
    [self setBarButtonItem];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    if (self.array == nil || self.array.count == 0) {
        
        UIAlertView * alert = [[UIAlertView alloc ]initWithTitle:@"提示" message:@"您还没有试听过任何节目,点击频道试试" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        alert.tag = 100;
        [self.view addSubview:alert];
        [alert show];
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:0.3];
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)dismissAlertView:(UIAlertView *)alertView

{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{

    [self.tableView reloadData];
}

// 返回按钮
- (void)setBarButtonItem
{
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"< 我的" style:UIBarButtonItemStylePlain target:self action:@selector(didClickBackButtonItemAction:)];
    self.navigationItem.leftBarButtonItem = back;
}

//点击返回按钮响应方法
- (void)didClickBackButtonItemAction:(UIBarButtonItem *)button
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if ([self.delegate respondsToSelector:@selector(backArrayCount:)])
    {
        [self.delegate backArrayCount:self.array.count];

    }

    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    

        TT_Detail *detail = self.array[indexPath.row];
        cell.textLabel.text = detail.title;
  
    
    // Configure the cell...
    cell.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;// 显示不下中间省略
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TT_Detail *detail = self.array[indexPath.row];
    TT_AppDelegate *appDelegate = (TT_AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.playFM = appDelegate.playFM;
    self.playFM.moviePlayer.contentURL =[NSURL URLWithString:detail.playUrl64];
    [self.playFM.moviePlayer play];
    
}


// 设置背景图片
- (void)setBackgroundImage
{
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    
    // 高斯效果
//    TT_GaussBlur *gaussBlur = [[TT_GaussBlur alloc] init];
//    UIImage *img = [gaussBlur getBlurImage:[UIImage imageNamed:@"lv"]];
//    self.imageView.image = img;
    self.imageView.image = [UIImage imageNamed:@"lv"];
    self.tableView.backgroundView = self.imageView;
}




@end
