//
//  TT_PlayViewController.m
//  TTFM
//
//  Created by Yinan on 14-11-19.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import "TT_PlayViewController.h"
#import "GifView.h"


@interface TT_PlayViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIButton *playAndPauseBtn;
@property (nonatomic,strong) UIButton *pauseButton;
@property (nonatomic,strong) UIButton *stopButton;
@property (nonatomic,strong) MPMoviePlayerViewController *playFM;
@property(retain, nonatomic) GifView *dataView;

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation TT_PlayViewController

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
    self.view.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.title = self.detail.title;
    
    [self setupBac];
    
    [self setButton];
    
    [self mediaPlayer];
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPalyAndPauseButtonImage:) name:@"SetPalyAndPauseButtonImage" object:nil];
  
}

#pragma mark - 通知方法

- (void)setPalyAndPauseButtonImage:(NSNotification *)notfic
{
    NSDictionary *dic = [notfic userInfo];
    NSString *imageName = [dic valueForKeyPath:@"imageName"];
    
    UIImage *image  = nil;
    if ([imageName isEqualToString:@"play"]) {
        image = [UIImage imageNamed:@"play.png"];
    }
    
    if ([imageName isEqualToString:@"pause"]) {
        image = [UIImage imageNamed:@"pause.png"];
    }
    
    [self.playAndPauseBtn setImage:image forState:UIControlStateNormal];
}

- (void)setupBac
{
    // 是否进行自动便宜，iOS7的新特性，只要UINavigationBar下面的视图是继承于UIScrollView，都可能存在这个情况，系统默认是YES
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, 320, 460)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(320*2, 450);
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    [self.view addSubview:self.scrollView];
    
    // 本地图片
    NSData *localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"music2" ofType:@"gif"]];
    
    self.dataView = [[GifView alloc] initWithFrame:CGRectMake(20, 40, 280, 300) data:localData];
    self.dataView.repeats = 0.7;
    [self.scrollView addSubview:_dataView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320, 20, 320, 350)];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.detail.coverLarge] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cacheType = SDImageCacheTypeDisk;
        self.imageView.image = image;
    }];
    

    
    [self.scrollView addSubview:self.imageView];
}

- (void)setButton
{
    
    self.playAndPauseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.playAndPauseBtn.frame = CGRectMake(130, 450, 60, 50);
    self.playAndPauseBtn.tintColor = [UIColor grayColor];
    [self.playAndPauseBtn setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    [self.playAndPauseBtn addTarget:self action:@selector(didPlayButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playAndPauseBtn];
    
}


- (void)mediaPlayer
{
    NSURL *sourceMovieURL= [NSURL URLWithString:self.detail.playUrl64];

    TT_AppDelegate *appDelegate = (TT_AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.playFM = appDelegate.playFM;
    self.playFM.moviePlayer.contentURL = sourceMovieURL;
    [self.playFM.moviePlayer play];
  
}


// 播放
- (void)didPlayButton
{
    BOOL playAndPause = [[NSUserDefaults standardUserDefaults] boolForKey:@"playAndPause"];
    
    if (playAndPause == YES) {
        [self.playFM.moviePlayer play];
        //[self.playAndPauseBtn setImage:[UIImage imageNamed:@"iconpause.png"] forState:UIControlStateNormal];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"playAndPause"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
    }else{
        
        [self.playFM.moviePlayer pause];
        //[self.playAndPauseBtn setImage:[UIImage imageNamed:@"iconplay.png"] forState:UIControlStateNormal];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"playAndPause"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
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
