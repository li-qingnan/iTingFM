//
//  TT_ChannelViewController.m
//  TTFM
//
//  Created by Yinan on 14-11-17.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import "TT_ChannelViewController.h"
#import "TT_ChannelCell.h"
#import "TT_ChannelListViewController.h"


@interface TT_ChannelViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
// collectionView
@property (nonatomic,strong) UICollectionView *collectionView;
// 接收model类数组
@property (nonatomic,strong) NSMutableArray *channelArr;

@end

@implementation TT_ChannelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.channelArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackgroundImage];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.view.backgroundColor = [UIColor clearColor];

    [self setupMainView];
    
    
    // 解析本地json
    [self parsingJson];

}

// 设置背景图片
- (void)setBackgroundImage
{
    TT_GaussBlur *gaussBlur = [[TT_GaussBlur alloc] init];
    self.backImageView.image = [gaussBlur getBlurImage:[UIImage imageNamed:@"lv"]];
}

// 解析本地json
- (void)parsingJson
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Channel" ofType:@"json"];

    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSArray *sourceArr = [data objectFromJSONData];
    
    self.channelArr = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in sourceArr) {
        
        TT_Channel *channel = [[TT_Channel alloc] init];
        [channel setValuesForKeysWithDictionary:dic];
        [self.channelArr addObject:channel];
        
    }
    
}


// 配置页面
- (void)setupMainView
{
   
    
    // 创建collectionView布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 10, 20, 10);
    
    // 创建collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 60, 320, iPhone5?460:370) collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[TT_ChannelCell class] forCellWithReuseIdentifier:@"cell"];
    

}



#pragma mark -  UICollectionViewDataSource

// 设置item数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.channelArr.count;
}

// cell高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(90, 78);
}

// 显示cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TT_ChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    //cell.backgroundColor = [UIColor yellowColor];
    
    TT_Channel *channel = self.channelArr[indexPath.row];
    cell.channel = channel;
    
    return cell;
}


#pragma mark -  UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TT_ChannelListViewController *channelListVC = [[TT_ChannelListViewController alloc] init];
    
    TT_Channel *channel = self.channelArr[indexPath.row];
    channelListVC.category = channel.name;
    channelListVC.aTitle = channel.title;
    
    [self.navigationController pushViewController:channelListVC animated:YES];
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
