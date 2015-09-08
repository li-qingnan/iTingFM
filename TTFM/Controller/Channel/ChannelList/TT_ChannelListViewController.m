//
//  TT_ChannelListViewController.m
//  TTFM
//
//  Created by Yinan on 14-11-18.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import "TT_ChannelListViewController.h"
#import "CZW_PriceStandardBackView.h"
#import "TT_TableViewController.h"



@interface TT_ChannelListViewController ()<UIScrollViewDelegate>

// loading
@property (nonatomic,strong) MulticolorView *loadingView;

// 存放model类
@property (nonatomic,strong) NSMutableArray *channelListArr;

// 图片url
@property (nonatomic,strong) NSMutableArray *pictureArray;

// tname
@property (nonatomic,strong) NSMutableArray *tnameArr;

// scr
@property (retain,nonatomic) UIScrollView *largeScrollView;
@property (retain,nonatomic) UIScrollView *smallScrollView;
@property (retain,nonatomic) UIPageControl *pageControl;

@property (assign,nonatomic) BOOL largeFlag;
@property (assign,nonatomic) BOOL smallFlag;
@property (assign,nonatomic) BOOL Flag;

@end

@implementation TT_ChannelListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.pictureArray = [[NSMutableArray alloc] init];
        self.channelListArr = [[NSMutableArray alloc] init];
        self.tnameArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.aTitle;
    [self.navigationController.navigationBar setAlpha:0.5];
    
    [self setBarButtonItem];
    [self setupLoadingView];
    
    Reachability * reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([reachability currentReachabilityStatus] == NotReachable) {
        UIAlertView * alert = [[UIAlertView alloc ]initWithTitle:@"提示" message:@"当前没有网络，请联网后收听" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        alert.tag = 100;
        [alert show];
    }else{
        // 加载数据
        [self requestData];
    }
    
    

}


// 显示导航栏
- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

// 返回按钮
- (void)setBarButtonItem
{
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"< 频道" style:UIBarButtonItemStylePlain target:self action:@selector(didClickBackButtonItemAction:)];
    self.navigationItem.leftBarButtonItem = back;
}

//点击返回按钮响应方法
- (void)didClickBackButtonItemAction:(UIBarButtonItem *)button
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// 请求数据
- (void)requestData
{
    // 通过category 查询数据库中的数据
    NSArray *array = [[NSArray alloc] init];
    array = [[TT_DatabaseHandle shareInstance] getAllChannelCategory:self.category];
    
    // 如果为空或数组内容为空  请求加载数据
    if (array == nil || [array count] == 0) {
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        __block TT_ChannelListViewController *channelListVC = self;
        dispatch_async(queue, ^{
            
            NSString *string = [NSString stringWithFormat:@"http://mobile.ximalaya.com/m/category_tag_list?device=ios&per_page=40&category=%@&type=album&page=1",self.category];
            NSURL *url = [NSURL URLWithString:string];
            
            NSData *data = [NSData dataWithContentsOfURL:url];
            
            if (data == nil) {
                
                UIAlertView * alert = [[UIAlertView alloc ]initWithTitle:@"提示" message:@"当前没有网络，请联网后收听" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [alert show];
                [self.view addSubview:alert];
                
                return ;
            }
            
            NSDictionary *sourceDic = [data objectFromJSONData];
            NSArray *sourceArr = [sourceDic objectForKey:@"list"];
            
            
            for (NSDictionary *dic in sourceArr) {
                
                TT_Channel *channel = [[TT_Channel alloc] init];
                [channel setValuesForKeysWithDictionary:dic];
                [self.channelListArr addObject:channel];
                
            }
            
            
            // pic Url
            for (TT_Channel *channel in self.channelListArr) {
                [channelListVC.pictureArray addObject:channel.cover_path];
            }
            
            // title
            for (TT_Channel *channel in self.channelListArr) {
                [channelListVC.tnameArr addObject:channel.tname];

            }
            
            [[TT_DatabaseHandle shareInstance] insertCategory:self.category tnameArr:self.tnameArr pictureArray:self.pictureArray];
            
            // 创建Scr
            [self createScrollView];
            
        });

    }else{//  如果存在 直接显示
        
        self.tnameArr = (NSMutableArray *)array[0];
        self.pictureArray = (NSMutableArray *)array[1];
        // 创建Scr
        [self createScrollView];
    }
    
   }

//设置loading
- (void)setupLoadingView
{
    self.loadingView = [[MulticolorView alloc] initWithFrame:CGRectMake(60, iPhone5?134:60, 200, 300)];
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
}

// 创建scr
- (void)createScrollView
{
    //self.view.backgroundColor = [UIColor colorWithWhite:0.91 alpha:0.95];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.largeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height-100)];
    self.smallScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-134, 320, 80)];
    
    self.largeScrollView.contentSize = CGSizeMake(self.largeScrollView.frame.size.width*self.pictureArray.count, self.largeScrollView.frame.size.height);
    self.smallScrollView.contentSize = CGSizeMake(100*self.pictureArray.count, self.smallScrollView.frame.size.height);
    
    self.smallScrollView.delegate = self;
    self.largeScrollView.delegate = self;
    
    self.largeScrollView.tag = 9001;
    self.smallScrollView.tag = 9002;
    
    self.largeScrollView.pagingEnabled = YES;
    self.smallScrollView.pagingEnabled = YES;
    
    self.largeScrollView.showsVerticalScrollIndicator = NO;
    self.smallScrollView.showsVerticalScrollIndicator = NO;
    self.largeScrollView.showsHorizontalScrollIndicator = YES;
    self.smallScrollView.showsHorizontalScrollIndicator = YES;
    
    CZW_PriceStandardBackView *largeBackView = [[CZW_PriceStandardBackView alloc]initWithFrame:_largeScrollView.frame];
    [self.view addSubview:largeBackView];
    
    CZW_PriceStandardBackView *smallBackView = [[CZW_PriceStandardBackView alloc]initWithFrame:self.smallScrollView.frame];
    [self.view addSubview:smallBackView];
    
    [self.view addSubview:self.largeScrollView];
    [self.view addSubview:self.smallScrollView];
    
    for (int i = 0 ; i<self.pictureArray.count; i++) {
        
        UIImageView *large =[[UIImageView alloc]initWithFrame:CGRectMake(i*320, 0, 320, iPhone5?240:200)];
        large.userInteractionEnabled = YES;
        UIImageView *small =[[UIImageView alloc]initWithFrame:CGRectMake(i*100, 0,90, 70)];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, iPhone5?245:220, 270, iPhone5?80:50)];
        label.text = [NSString stringWithFormat:@"%@",self.tnameArr[i]];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:30];
        [large addSubview:label];
        

        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTapGestureAction:)];
        [large addGestureRecognizer:tap];
        
        
        NSURL *largeUrl =[NSURL URLWithString:self.pictureArray[i]];
        NSURL *smallUrl =[NSURL URLWithString:self.pictureArray[i]];

        
        // 下载到沙盒中 先从沙盒中取 然后再请求数据
        [large sd_setImageWithURL:largeUrl placeholderImage:[UIImage imageNamed:@"lv"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cacheType = SDImageCacheTypeDisk;
            large.image = image;
        }];
        
        [small sd_setImageWithURL:smallUrl placeholderImage:[UIImage imageNamed:@"lv"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cacheType = SDImageCacheTypeDisk;
            small.image = image;
        }];
        
        
        [self.largeScrollView addSubview:large];
        [self.smallScrollView addSubview:small];
    }
    

    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(100, 390, 220, 30)];
    self.pageControl.numberOfPages = self.pictureArray.count;
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];//圆点未显示颜色
    self.pageControl.currentPageIndicatorTintColor = [UIColor greenColor];//当前显示圆点颜色
    [self.view addSubview:self.pageControl];
    
    [self.pageControl addTarget:self action:@selector(handlePageControlAction:) forControlEvents:UIControlEventValueChanged];

}


//添加 pageControl 响应方法
- (void)handlePageControlAction:(UIPageControl *)pageControl
{

    //计算页数对应的偏移量 x
    CGPoint offset = CGPointMake(pageControl.currentPage * self.largeScrollView.frame.size.width, 0);
    
    //修改 scrollView 的 contentOffset(偏移量)
    [self.largeScrollView setContentOffset:offset animated:YES];//给定偏移量 设置动画效果
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView.tag == 9001) {
        self.largeFlag = YES;
    }
    if (scrollView.tag == 9002) {
        self.smallFlag = YES;
    }
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x>0) {
        if (scrollView.tag == 9001) {
            float x= round(scrollView.contentOffset.x/320.0);
            if (self.largeFlag == YES) {
                if (x<self.pictureArray.count-2) {
                    [self.smallScrollView setContentOffset:CGPointMake(x*100, 0) animated:YES];
                    
                }
            }
        }
        if (scrollView.tag == 9002) {
            float x= round(scrollView.contentOffset.x/100.0);
            if (self.smallFlag == YES) {
                [self.largeScrollView setContentOffset:CGPointMake(x*320, 0) animated:YES];
            }
        }
    }
    
    
    if (scrollView.contentOffset.x<-80 && _Flag == YES) {
        [self.navigationController popViewControllerAnimated:YES];
        _Flag = NO;
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (scrollView.tag == 9001) {
        self.largeFlag = NO;
        
        //计算 scrollView 停留在哪一页
        CGPoint offset = scrollView.contentOffset;//计算偏移量
        
        NSInteger pageNumber = offset.x / scrollView.frame.size.width;
        
        //修改 pageControl 页数
        self.pageControl.currentPage = pageNumber;
        
    }
    
    if (scrollView.tag == 9002) {
        self.smallFlag = NO;
        
        //计算 scrollView 停留在哪一页
        CGPoint offset = scrollView.contentOffset;//计算偏移量
        
        NSInteger pageNumber = offset.x / scrollView.frame.size.width;
        
        //修改 pageControl 页数
        self.pageControl.currentPage = pageNumber;
        
    }
}


- (void)clickTapGestureAction:(UITapGestureRecognizer *)gesture
{
    // 通过手势加载哪个view上获取子view得到button
   UILabel *label = gesture.view.subviews[0];
   
    NSString *string = label.text;

    
    TT_TableViewController *vc = [[TT_TableViewController alloc] init];
    vc.category_name = self.category;
    vc.tag_name = string;
    
    Reachability * reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([reachability currentReachabilityStatus] == NotReachable) {
        UIAlertView * alert = [[UIAlertView alloc ]initWithTitle:@"提示" message:@"当前没有网络，请联网后收听" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        alert.tag = 100;
        [alert show];
    }else{

        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
