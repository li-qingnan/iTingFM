//
//  TT_GuidepageViewController.m
//  TTFM
//
//  Created by Yinan on 14-11-25.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import "TT_GuidepageViewController.h"

@interface TT_GuidepageViewController ()<UIScrollViewDelegate>

@property(nonatomic,retain)UIPageControl *pageControl;
@property(nonatomic,retain)UIScrollView *scrollView;

@end

@implementation TT_GuidepageViewController

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
    [self setupScrView];
}

- (void)setupScrView
{

    self.scrollView =[[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.scrollView .contentSize =CGSizeMake(self.view.bounds.size.width*5, self.view.bounds.size.height);
    self.scrollView .pagingEnabled = YES;
    self.scrollView .bounces = NO;
    self.scrollView .delegate = self;
    [self.view addSubview:self.scrollView ];
    
    UIImageView * imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320,self.view.bounds.size.height)];
    imageView1.image =[UIImage imageNamed:@"background_01@2x"];
    [self.scrollView  addSubview:imageView1];

    
    UIImageView * imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(320, 0, 320,self.view.bounds.size.height)];
    imageView2.image =[UIImage imageNamed:@"background_02@2x"];
    [self.scrollView  addSubview:imageView2];

    
    UIImageView * imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(320*2, 0, 320,self.view.bounds.size.height)];
    imageView3.image =[UIImage imageNamed:@"background_03@2x"];
    [self.scrollView addSubview:imageView3];
    
    UIImageView * imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(320*3, 0, 320,self.view.bounds.size.height)];
    imageView4.image =[UIImage imageNamed:@"background_04@2x"];
    [self.scrollView addSubview:imageView4];
    
    UIImageView * imageView5 = [[UIImageView alloc] initWithFrame:CGRectMake(320*4, 0, 320,self.view.bounds.size.height)];
    imageView5.userInteractionEnabled = YES;
    imageView5.image =[UIImage imageNamed:@"background_05@2x"];
    [self.scrollView addSubview:imageView5];

    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height-80, 320, 40)];
    self.pageControl.numberOfPages = 5;
    [self.view addSubview:self.pageControl];
    [self.pageControl addTarget:self action:@selector(handlePageControlAction:) forControlEvents:UIControlEventValueChanged];
    
    
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    button.frame = CGRectMake(100, self.view.frame.size.height-100, 120, 30);
    [button setTitle:@"开启爱听" forState:(UIControlStateNormal)];
    button.layer.borderColor = [[UIColor whiteColor] CGColor];
    button.layer.borderWidth = 1.0f;
    button.layer.shadowColor = [[UIColor blackColor] CGColor];
    button.layer.shadowOffset = CGSizeMake(2.5, 2.0);
    button.layer.shadowOpacity = 0.8;
    button.tintColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    [button addTarget:self action:@selector(firstPressed) forControlEvents:(UIControlEventTouchUpInside)];
    [imageView5 addSubview:button];
}

- (void)handlePageControlAction:(UIPageControl*)pageControl
{
    
    CGPoint offset=CGPointMake(pageControl.currentPage*self.scrollView.frame.size.width, 0);
    //修改scrollView的contentOffset
    [self.scrollView setContentOffset:offset animated:YES];
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentPage = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.pageControl.currentPage = currentPage;
}




//按钮响应方法
- (void)firstPressed
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];//如果bundle给nil的话默认是MainBundle
    UITabBarController *tabBarVC = [mainStoryboard instantiateInitialViewController];
    
    [self presentViewController:tabBarVC animated:YES completion:nil];
    
    // 强转rootVC
    self.view.window.rootViewController = tabBarVC;
    
    // 让代理创建播放暂停按钮
    if ([self.delegate respondsToSelector:@selector(createPlayButton)]) {
        [self.delegate createPlayButton];
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
