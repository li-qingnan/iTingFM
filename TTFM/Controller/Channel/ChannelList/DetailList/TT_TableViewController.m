//
//  TT_TableViewController.m
//  TTFM
//
//  Created by Yinan on 14-11-18.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import "TT_TableViewController.h"
#import "TT_TableViewCell.h"
#import "TT_DetailPlayViewController.h"


@interface TT_TableViewController ()

@property (nonatomic,strong) NSMutableArray *detailArr;
// loading
@property (nonatomic,strong) MulticolorView *loadingView;

@end

@implementation TT_TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.tag_name;
    
    //不显示tableView的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;


    [self.tableView registerClass:[TT_TableViewCell class] forCellReuseIdentifier:@"cell"];
    
    Reachability * reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([reachability currentReachabilityStatus] == NotReachable) {
        UIAlertView * alert = [[UIAlertView alloc ]initWithTitle:@"提示" message:@"当前没有网络，请联网后收听" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }else{
        
        [self requestData];
    }
    
    
}



//设置loading
- (void)setupLoadingView
{
    
    self.loadingView = [[MulticolorView alloc] initWithFrame:CGRectMake(60, iPhone5?80:60, 200, 300)];
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
}

// 请求数据
- (void)requestData
{
  NSArray *array = [[TT_DatabaseHandle shareInstance] getAllDetailListTagname:self.tag_name];
    
    if (array == nil || array.count == 0) {
    [self setupLoadingView];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        __block TT_TableViewController *VC = self;
        dispatch_async(queue, ^{
            
            NSString *str = [NSString stringWithFormat:@"http://mobile.ximalaya.com/m/explore_album_list?category_name=%@&condition=hot&device=ios&page=1&per_page=20&status=0&tag_name=%@",self.category_name,self.tag_name];
            
            // encoding转换
            NSString *urlStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:urlStr];
            NSData *data = [NSData dataWithContentsOfURL:url];
            
            [self.loadingView removeFromSuperview];
            
            if (data == nil) {
                
                UIAlertView * alert = [[UIAlertView alloc ]initWithTitle:@"提示" message:@"当前没有网络，请联网后收听" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [alert show];
                return ;
            }
            
            NSDictionary *sourceDic = [data objectFromJSONData];
            NSArray *sourceArr = [sourceDic objectForKey:@"list"];
            
            
            self.detailArr = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dic in sourceArr) {
                
                TT_Detail *detail = [[TT_Detail alloc] init];
                [detail setValuesForKeysWithDictionary:dic];
                [VC.detailArr addObject:detail];
            }
            
            [[TT_DatabaseHandle shareInstance] insertTagname:self.tag_name detailListArr:self.detailArr];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                
            });
        });

    }else{
    
        self.detailArr =(NSMutableArray *) array;
        [self.loadingView removeFromSuperview];
        [self.tableView reloadData];
     
    }

    
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
    return self.detailArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TT_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    TT_Detail *detail = self.detailArr[indexPath.row];
    cell.detail = detail;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    TT_Detail *detail = self.detailArr[indexPath.row];

    TT_DetailPlayViewController *playVC = [[TT_DetailPlayViewController alloc] init];
    playVC.ID = (NSString *)detail.ID;
    
    Reachability * reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([reachability currentReachabilityStatus] == NotReachable) {
        UIAlertView * alert = [[UIAlertView alloc ]initWithTitle:@"提示" message:@"当前没有网络，请联网后收听" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }else{
        
      [self.navigationController pushViewController: playVC animated:YES];
    }
    
    
    

}



@end
