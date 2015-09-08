//
//  TT_FunctionViewController.m
//  TTFM
//
//  Created by 李一楠 on 14/11/24.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import "TT_FunctionViewController.h"

@interface TT_FunctionViewController ()<UITextViewDelegate>

@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation TT_FunctionViewController

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
    [self setBackgroundImage];
    self.view.backgroundColor = [UIColor clearColor];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationItem.title = @"功能简介";
    [self setBarButtonItem];
    [self setShow];
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)setShow
{

    UITextView *introduction = [[UITextView alloc] initWithFrame:CGRectMake(10, 60, 300, iPhone5?460:380)];
    introduction.delegate = self;
    introduction.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    introduction.backgroundColor = [UIColor clearColor];
    introduction.textColor = [UIColor whiteColor];
    introduction.text = @"i听电台(i听FM)将成为你的专属个性化音乐收听工具。\n我们提供三个主要页面如下:\n1.  随心听,随机播放音乐类电台,让我们一起聆听动听的音乐。\n                         \n2.  频道列表,我们提供多个列表供您任意选择,音乐、经济、娱乐、相声、外语、教育、都市、体育、小说等多个电台频道，24小时不间断提供在线收听。\n                         \n3.   我的页面,显示您的试听记录,以及清除缓存。\n                         \n 操作提示:\n1. 屏幕小白点,提供任意页面的播放暂停切换\n                         \n2. 如果在频道页面播放节目,回到随心听界面需要点击音乐图片才可以开始播放音乐。如果网络中断,需要点击刷新按钮播放。\n                         \n3. 在频道页播放节目,如果想暂停的话,需要点击小白点,如果点击圆圈播放按钮,因为重新加载数据暂停之后再播放就是从新开始播放,敬请谅解。\n                         \n如果您有好的意见或建议,请联系我,\n李青楠 595567894@qq.com\n我们会根据您的意见和建议,努力完善应用,更多功能敬请期待。";
    [self.view addSubview:introduction];
}
// 不能编辑
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
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
    [self.view addSubview:self.imageView];
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
