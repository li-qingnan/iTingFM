//
//  TT_ListenViewController.m
//  TTFM
//
//  Created by Yinan on 14-11-17.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import "TT_ListenViewController.h"
#import "TT_SongModel.h"
#import "UIImage+LK.h"
#import "Reachability.h"

@interface TT_ListenViewController ()

@end

@implementation TT_ListenViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.array = [[NSMutableArray alloc]init];
        self.prsentStateIndex = 0;
        self.playAndPause = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.backgroundImageView.image = [UIImage imageNamed:@"lv.png"];
    
    Reachability * reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([reachability currentReachabilityStatus] == NotReachable) {
        UIAlertView * alert = [[UIAlertView alloc ]initWithTitle:@"提示" message:@"当前没有网络，请联网后收听" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        alert.tag = 100;
        [alert show];
    }else{
        // 默认加载第一个数据
        [self requestUrl:1];
    }
    

    // 添加sellectionView
    [self addCollectionView];
    // 添加选项卡
    [self addDropDownMenu];
    
    // 创建播放器
    [self createMPVC];
    
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


// 创建播放器
- (void)createMPVC
{
  
    TT_AppDelegate *appDelegate = (TT_AppDelegate *)[[UIApplication sharedApplication] delegate];

    //添加观察者判断时候播放完
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    self.playFM = appDelegate.playFM;

}

//观察者响应事件，如果一首歌播放完，继续播放下一首，如果播放到最后一首则刷新数据
- (void)movieFinished:(NSNotification *)notify
{
    _prsentStateIndex++;
    
    if (_prsentStateIndex < self.array.count) {
        [self isDelected:_prsentStateIndex];
    }
    if (_prsentStateIndex == self.array.count) {
        [self refreshBtn:nil];
    }
}

//添加选项卡
- (void)addDropDownMenu
{
    
    //选择FM类型
    NSArray * typeArray = @[@"华 语",@"欧 美",@"七 零",@"八 零",@"九 零",@"粤 语",@"摇 滚",@"民 谣",@"轻音乐",@"电影原声"];
    NSMutableArray * dropdownItems = [[NSMutableArray alloc]init];
    for (int i = 0; i < typeArray.count; i++) {
        IGLDropDownItem * item = [[IGLDropDownItem alloc]init];
        [item setText:typeArray[i]];
        [dropdownItems addObject:item];
    }
    //选择卡
    self.dropDownMenu = [[IGLDropDownMenu alloc]init];
    self.dropDownMenu.menuText = @"华 语";
    self.dropDownMenu.dropDownItems = dropdownItems;
    self.dropDownMenu.paddingLeft = 15;
    [self.dropDownMenu setFrame:CGRectMake(20, 82, 120, iPhone5?30:20)];
    self.dropDownMenu.delegate = self;
    [self setUpParams];
    [self.dropDownMenu reloadView];
    [self.view addSubview:self.dropDownMenu];
  
}

//添加CollectionView
- (void)addCollectionView
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = (iPhone5?30:20);
    layout.sectionInset = UIEdgeInsetsMake(30, 15, iPhone5?30:90, 30);
    
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 140, 320, 360) collectionViewLayout:layout];
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"celltype"];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:collectionView];

}


//选择音乐类型按钮
- (void)setUpParams
{
    self.dropDownMenu.type = IGLDropDownMenuTypeStack;
    self.dropDownMenu.gutterY = 10;
    self.dropDownMenu.itemAnimationDelay = 0.1;
    self.dropDownMenu.rotate = IGLDropDownMenuRotateRandom;
}


#pragma mark --IGLDropDownMenuDelegate

//选择对应类型FM
- (void)selectedItemAtIndex:(NSInteger)index
{
    //IGLDropDownItem * item = self.dropDownMenu.dropDownItems[index];
    //删除存在字典里的所有music URL
    [self.titleLabel.layer removeAllAnimations];
    //self.playAndPause = YES;
    self.prsentIndex = (int)index;
    [self requestUrl:(int)index+1];
}

//实现代理方法
- (void)jsonDataDidFinishLoad:(NSMutableArray *)array
{
    //获取数据并加载第一条
    self.array = [NSMutableArray arrayWithArray:array];
    //指定显示第一条数据
    [self isDelected:0];
    
    [self.collectionView reloadData];
}

//加载数据
- (void)requestUrl:(int)count
{
    
    FMResolve * fmresolve = [[FMResolve alloc]init];
    NSString * urlStr = [fmresolve urlStr:count];
    fmresolve.delegate = self;
    [fmresolve JsonData:urlStr];

}

#pragma mark --UICollectionView--

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"celltype" forIndexPath:indexPath];
    TT_SongModel * songModel = [[TT_SongModel alloc]init];
    NSMutableDictionary * dic = [self.array objectAtIndex:indexPath.row];
    [songModel setValuesForKeysWithDictionary:dic];
    
    
    //解析下载图片
    UIImageView * imageView = [[UIImageView alloc]init];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:songModel.picture] placeholderImage:[UIImage imageNamed:@"lv"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cacheType = SDImageCacheTypeDisk;
        
        imageView.image = image;
    }];

    //根据图片大小缩放图片
    imageView.image = [UIImage imageWithImage:imageView.image ratioToSize:CGSizeMake(130, 130)];
    //添加阴影
    imageView.layer.shadowColor = [UIColor clearColor].CGColor;
    imageView.layer.shadowOffset = CGSizeMake(4, 4);
    imageView.layer.shadowOpacity = 0.8;
    imageView.layer.shadowRadius = 4;
    
    
    [cell setBackgroundView:imageView];

    return cell;
}


//cell 的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake ((iPhone5?130:135), (iPhone5?130:100));
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //[self.playFM.moviePlayer stop];
    _prsentStateIndex = (int)indexPath.row;
    
    Reachability * reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([reachability currentReachabilityStatus] == NotReachable) {
        UIAlertView * alert = [[UIAlertView alloc ]initWithTitle:@"提示" message:@"当前没有网络，请联网后收听" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }else{
        
        //显示选中的数据
        [self isDelected:indexPath.row];
    }
}

//解析指定数组内的数据并显示
- (void)isDelected:(NSInteger)index
{
    NSMutableDictionary * dic = [self.array objectAtIndex:index];
    TT_SongModel * songModel = [[TT_SongModel alloc]init];
    [songModel setValuesForKeysWithDictionary:dic];
    self.titleLabel.text = songModel.title;
    self.artistLabel.text = songModel.artist;

  
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:songModel.picture] placeholderImage:[UIImage imageNamed:@"lv"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cacheType = SDImageCacheTypeDisk;
        
        TT_GaussBlur *gaussBlur = [[TT_GaussBlur alloc] init];
        self.backgroundImageView.image = [gaussBlur getBlurImage:image];
    }];
    
    
    [self.playFM.moviePlayer setContentURL:[NSURL URLWithString:songModel.url]];
    [self.playFM.moviePlayer play];
    
    [self.playAndPauseBtn setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    
    //计算标题的长度
    CGRect rect = [songModel.title boundingRectWithSize:CGSizeMake(1000, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:32]} context:nil];
    self.titleLabel.frame = CGRectMake(10, 20, rect.size.width+50, 50);

    
    [self.titleLabel.layer removeAllAnimations];
    //判断标题长度如果超过320则开始滚动，将标题显示全
    if (rect.size.width > 320.0) {
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
        animation.fromValue = [NSNumber numberWithFloat:0];
        animation.toValue = [NSNumber numberWithFloat:-(rect.size.width-280)];
        
        animation.duration = 7.0;
        animation.repeatCount = 360;
        animation.autoreverses = YES;
        animation.removedOnCompletion = YES;
        animation.fillMode = kCAFillModeForwards;
        
        [self.titleLabel.layer addAnimation:animation forKey:@"animateLayer"];
        
    }
   
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)playAndPause:(id)sender {
    

    Reachability * reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([reachability currentReachabilityStatus] == NotReachable) {
        UIAlertView * alert = [[UIAlertView alloc ]initWithTitle:@"提示" message:@"当前没有网络，请联网后收听" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        alert.tag = 100;
        [alert show];
    }else{
 
       //BOOL playAndPause = [[NSUserDefaults standardUserDefaults] boolForKey:@"playAndPause"];
        
        if (self.playAndPause == YES) {
            
            [self.playFM.moviePlayer play];
            [self.playAndPauseBtn setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
            self.playAndPause = NO;
            
    //        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"playAndPause"];
    //        [[NSUserDefaults standardUserDefaults]synchronize];

            
        }else{
            
            [self.playFM.moviePlayer pause];
            [self.playAndPauseBtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
            self.playAndPause = YES;

    //        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"playAndPause"];
    //        [[NSUserDefaults standardUserDefaults]synchronize];

        }
        
    }
    
}

- (IBAction)refreshBtn:(id)sender
{
    
    _prsentStateIndex = 0;
    [self.titleLabel.layer removeAllAnimations];
    
    Reachability * reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([reachability currentReachabilityStatus] == NotReachable) {
        UIAlertView * alert = [[UIAlertView alloc ]initWithTitle:@"提示" message:@"当前没有网络，请联网后收听" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        alert.tag = 100;
        [alert show];
    }else{
        
      [self requestUrl:self.prsentIndex+1];
        
    }
}
@end
