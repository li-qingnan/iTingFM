//
//  TT_DetailPlayViewController.m
//  TTFM
//
//  Created by 李一楠 on 14/11/26.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import "TT_DetailPlayViewController.h"
#import "TT_DetailTableViewCell.h"

@interface TT_DetailPlayViewController ()<TT_DetailTableViewCellPalyDelegate>

@property (nonatomic,strong) NSMutableArray *detailArr;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIImageView *imageView;


// loading
@property (nonatomic,strong) MulticolorView *loadingView;

@property (nonatomic,strong) MPMoviePlayerViewController *moviePlayer;

@end

@implementation TT_DetailPlayViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.playAndPause = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self requestData];
    [self setupMainView];
}

- (void)setupMainView
{
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 320, 180)];
    headerView.image = [UIImage imageNamed:@"headView.png"];
    self.tableView.tableHeaderView = headerView;
    //不显示tableView的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[TT_DetailTableViewCell class] forCellReuseIdentifier:@"DetailTableViewCell"];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(20, 112, 280, 80)];
    self.label.textColor = [UIColor whiteColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.numberOfLines = 0;
    [self.tableView.tableHeaderView addSubview:self.label];
    
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 25, 110, 110)];
    _imageView.layer.cornerRadius = 55;//设置圆角
    self.imageView.layer.masksToBounds = YES;
    [self.tableView.tableHeaderView addSubview:self.imageView];
}

// 请求数据
- (void)requestData
{
    
    NSArray * array = [[TT_DatabaseHandle shareInstance] getAllDetailListID:self.ID];
    
    if (array == nil || array.count == 0) {
        
        [self setupLoadingView];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        __block TT_DetailPlayViewController *VC = self;
        dispatch_async(queue, ^{

            
            NSString *str = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/others/ca/album/track/%@/true/1/15",self.ID];
            
            // encoding转换
            NSString *urlStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:urlStr];
            NSData *data = [NSData dataWithContentsOfURL:url];
            
            [self.loadingView removeFromSuperview];
            
            if (data == nil) {
                
                UIAlertView * alert = [[UIAlertView alloc ]initWithTitle:@"提示" message:@"当前没有网络，请联网后收听" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [alert show];
                [self.view addSubview:alert];
                
                return ;
            }
            
            NSDictionary *sourceDic = [data objectFromJSONData];
            NSDictionary *dic = [sourceDic objectForKey:@"album"];
            
            TT_Detail *detail = [[TT_Detail alloc] init];
            [detail setValuesForKeysWithDictionary:dic];
            
            NSDictionary *dic1 = [sourceDic objectForKey:@"tracks"];
            NSArray *sourceArr = [dic1 objectForKey:@"list"];
            
            
            self.detailArr = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dic in sourceArr) {
                
                TT_Detail *detail = [[TT_Detail alloc] init];
                [detail setValuesForKeysWithDictionary:dic];
                [VC.detailArr addObject:detail];
            }
            
            [[TT_DatabaseHandle shareInstance] insertID:self.ID dic:dic detailArr:self.detailArr];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.label.text = detail.tags;
                
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:detail.coverLarge]  placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    cacheType = SDImageCacheTypeDisk;
                    self.imageView.image = image;
                }];
                
                
                [self.tableView reloadData];
                
            });
            
            
        });
        
    }else{
        
        
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{

            
            NSDictionary *dic = array[0];
            TT_Detail *detail = [[TT_Detail alloc] init];
            [detail setValuesForKeysWithDictionary:dic];
            
            
            [self.loadingView removeFromSuperview];
            
            self.detailArr = (NSMutableArray *)array[1];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.label.text = detail.tags;
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:detail.coverLarge]  placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    cacheType = SDImageCacheTypeDisk;
                    self.imageView.image = image;
                }];
                
                
                [self.tableView reloadData];
                
            });
            
        });
        
        
    }
    
}


//设置loading
- (void)setupLoadingView
{
    
    self.loadingView = [[MulticolorView alloc] initWithFrame:CGRectMake(60, iPhone5?134:60, 200, 300)];
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
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
    return 135;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TT_DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailTableViewCell" forIndexPath:indexPath];
    
    TT_Detail *detail = self.detailArr[indexPath.row];
    cell.detail = detail;
    cell.delegate = self;
    
    // cell不能选中
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

// 执行代理方法
- (void)playDetailDetail:(TT_Detail *)detail
{
    
    NSURL *sourceMovieURL = [NSURL URLWithString:detail.playUrl64];
    
    TT_AppDelegate *appDelegate = (TT_AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.moviePlayer = appDelegate.playFM;
    
    [self.moviePlayer.moviePlayer stop];
    self.moviePlayer.moviePlayer.contentURL = sourceMovieURL;
    
    //    if (self.playAndPause == YES) {
    [self.moviePlayer.moviePlayer play];
    //        self.playAndPause = NO;
    //    }else{
    //        [self.moviePlayer.moviePlayer pause];
    //        self.playAndPause = YES;
    //    }
    
    
    // 查询是否存在
    BOOL isListon = [[TT_DatabaseHandle shareInstance] selectListonID: (NSString *)detail.trackId];
    
    // 根据ID查询  判断是否存在 不存在添加数据
    if (isListon == NO) {
        
        [[TT_DatabaseHandle shareInstance] insertID:(NSString *)detail.trackId playUrl:detail.playUrl64 title:detail.title picUrl:detail.coverLarge];
    }else{

    }
}




@end
