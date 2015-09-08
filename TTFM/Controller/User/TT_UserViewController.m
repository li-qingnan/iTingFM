//
//  TT_UserViewController.m
//  TTFM
//
//  Created by 李一楠 on 14/11/22.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import "TT_UserViewController.h"
#import "TT_ListonTableViewController.h"
#import "TT_FunctionViewController.h"

@interface TT_UserViewController ()

// loading
@property (nonatomic,strong) MulticolorView *loadingView;

@property (nonatomic,assign) NSInteger count;

@end

@implementation TT_UserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self setTableView];

}

- (void)viewWillAppear:(BOOL)animated
{
    [self setBackgroundImage];
    [self.settingTableView reloadData];
}

// 代理方法
- (void)backArrayCount:(NSInteger)count
{
    self.count = count;
    
}

- (void)setTableView
{
    
    self.settingTableView.backgroundColor = [UIColor clearColor];
    
    self.settingTableView.delegate = self;
    self.settingTableView.dataSource = self;
    
    [self.settingTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}


// 设置背景图片
- (void)setBackgroundImage
{
    // 高斯效果
//    TT_GaussBlur *gaussBlur = [[TT_GaussBlur alloc] init];
//    self.imageView.image = [gaussBlur getBlurImage:[UIImage imageNamed:@"lv"]];
    self.imageView.image = [UIImage imageNamed:@"lv"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
// 分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    
    if (tableView.tag == 101) {
        return 3;
    }
  
    return 0;
}


// 自定义headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero] ;
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor lightGrayColor];
    //headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:22];
    headerLabel.frame = CGRectMake(20, 0, 300, 30);

    
    if (section == 0) {
        headerLabel.text = @"我的";
    }
    
    [customView addSubview:headerLabel];
    
    if (tableView.tag == 101) {
        return customView;
    }
 
    return nil;
}
// 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 101) {
        return 50;
    }
    return 0;
}
// headerView高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

// 显示cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    if (tableView.tag == 101) {
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"爱听指引";
        }
        if (indexPath.row == 1) {
         
            
            cell.textLabel.text = @"试听记录";
            //[NSString stringWithFormat:@"试听记录                              %ld",(long)self.count];
        }
        if (indexPath.row == 2) {
            
            // 获取缓存大小
            NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            NSString *floderPath = [cachesPath stringByAppendingPathComponent:@"com.hackemist.SDWebImageCache.default"];
            
            float folderSize = [self folderSizeAtPath:floderPath];
            cell.textLabel.text = [NSString stringWithFormat:@"清除缓存                       %.2fMB",folderSize];
        }
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;// cell选中类型
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        TT_FunctionViewController *functionVC = [[TT_FunctionViewController alloc] init];
        [self.navigationController pushViewController:functionVC animated:YES];
    }
    if (indexPath.row == 1) {
        
        TT_ListonTableViewController *listonVC = [[TT_ListonTableViewController alloc] init];
        listonVC.delegate = self;
        [self.navigationController pushViewController:listonVC animated:YES];
    }
    if (indexPath.row == 2) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认清除所有本地缓存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [self.view addSubview:alertView];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {

        [self setupLoadingView];
        // 清除缓存图片
        [[SDImageCache sharedImageCache] clearDisk];
        
        // 删除试听记录
        NSFileManager *fileManager=[[NSFileManager alloc]init];
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dbPath = [cachePath stringByAppendingPathComponent:@"Liston.sqlite"];
        [fileManager removeItemAtPath:dbPath error:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
   
            [self.loadingView removeFromSuperview];
            [self.settingTableView reloadData];

        });
    }
    
}


//设置loading
- (void)setupLoadingView
{
    self.loadingView = [[MulticolorView alloc] initWithFrame:CGRectMake(60, iPhone5?134:50, 200, 300)];
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
}

//用于删除缓存的时，计算缓存大小
//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
