//
//  TT_AppDelegate.h
//  TTFM
//
//  Created by Yinan on 14-11-17.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TT_GuidepageViewController.h"
@interface TT_AppDelegate : UIResponder <UIApplicationDelegate,UIScrollViewDelegate,TT_GuidepageViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

// 播放器
@property (nonatomic,strong) MPMoviePlayerViewController *playFM;
// 播放暂停按钮
@property (nonatomic,strong) UIButton *playAndPauseBtn;

@end


/*
self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
// Override point for customization after application launch.
self.window.backgroundColor = [UIColor whiteColor];
[self.window makeKeyAndVisible];

// 光改plist不能后台  加上这句后台OK
AVAudioSession *session = [AVAudioSession sharedInstance];
[session setActive:YES error:nil];
[session setCategory:AVAudioSessionCategoryPlayback error:nil];

// 启用远程控制事件接收
[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

// 注册通知
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPalyAndPauseButtonImage:) name:@"SetPalyAndPauseButtonImage" object:nil];


if (![[NSUserDefaults standardUserDefaults] boolForKey:@"1"]) {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"1"];
    
    TT_GuidepageViewController * GuidepageVC = [[TT_GuidepageViewController alloc] init];
    self.window.rootViewController = GuidepageVC;
    
}else{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];//如果bundle给nil的话默认是MainBundle
    UITabBarController *tabBarVC = [mainStoryboard instantiateInitialViewController];
    
    self.window.rootViewController = tabBarVC;
    
    // 创建播放器
    [self createPlayFM];
    
}




 

 
 */
