//
//  TT_AppDelegate.m
//  TTFM
//
//  Created by Yinan on 14-11-17.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import "TT_AppDelegate.h"
#import "TT_GuidepageViewController.h"
#import "UIButton+NMCategory.h"

@implementation TT_AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    // Override point for customization after application launch.
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
    
    // 创建播放器
    [self createPlayFM];
    
    // 光改plist不能后台  加上这句后台OK
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    // 启用远程控制事件接收
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPalyAndPauseButtonImage:) name:@"SetPalyAndPauseButtonImage" object:nil];
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"first"]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first"];
        
        TT_GuidepageViewController *guidepageVC = [[TT_GuidepageViewController alloc] init];
        self.window.rootViewController  = guidepageVC;
        
        // 设置代理 在第一次进入的时候创建播放暂停按钮
        guidepageVC.delegate = self;
        
 }else{
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];//如果bundle给nil的话默认是MainBundle
        UITabBarController *tabBarVC = [mainStoryboard instantiateInitialViewController];
        
        self.window.rootViewController = tabBarVC;
        [self createPlayAndPauseButton];
    }

    
    return YES;
}

// 执行引导页代理方法
- (void)createPlayButton
{
    [self createPlayAndPauseButton];
}


// 创建播放器
- (void)createPlayFM
{
    self.playFM = [[MPMoviePlayerViewController alloc]init];
    [self.playFM.moviePlayer setControlStyle:MPMovieControlStyleNone];
    [self.playFM.view setFrame:CGRectMake(0, 0, 0, 0)];

}

// 创建播放暂停按钮
- (void)createPlayAndPauseButton
{
    // 设置播放暂停状态
    //    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"playAndPause"];
    //    [[NSUserDefaults standardUserDefaults]synchronize];
    
    self.playAndPauseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.playAndPauseBtn.frame = CGRectMake(0, 200, 60, 60);
    [self.playAndPauseBtn setImage:[UIImage imageNamed:@"pauseMain.png"] forState:UIControlStateNormal];
    
    // 吸附
    [self.playAndPauseBtn setAdsorbEnable:YES];
    [self.playAndPauseBtn setDragEnable:YES];
    
    self.playAndPauseBtn.tintColor = [UIColor grayColor];
    [self.playAndPauseBtn addTarget:self action:@selector(playAndPauseMusic) forControlEvents:UIControlEventTouchUpInside];

    [self.window.rootViewController.view addSubview:self.playAndPauseBtn];

    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    //添加到 imageView 上
    [self.playAndPauseBtn addGestureRecognizer:panGesture];
}


- (void)playAndPauseMusic
{
   BOOL playAndPause = [[NSUserDefaults standardUserDefaults] boolForKey:@"playAndPause"];
    
    if (playAndPause == YES) {
        
        [self.playFM.moviePlayer play];
        //[self.playAndPauseBtn setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];

        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"playAndPause"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObject:@"pause" forKey:@"imageName"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SetPalyAndPauseButtonImage" object:self userInfo:dic];
    
    }else{
        
        [self.playFM.moviePlayer pause];
        //[self.playAndPauseBtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"playAndPause"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObject:@"play" forKey:@"imageName"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SetPalyAndPauseButtonImage" object:self userInfo:dic];
    }
    
    playAndPause = !playAndPause;
}

//当平移手势识别器在 imageView 上识别到平移手势时,触发 controller 执行下面方法
- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{

    CGPoint translation = [gesture translationInView:gesture.view];//自动计算
    gesture.view.center = CGPointMake(gesture.view.center.x + translation.x, gesture.view.center.y + translation.y);

    [gesture setTranslation:CGPointZero inView:gesture.view];
    
}

#pragma mark - 通知方法

- (void)setPalyAndPauseButtonImage:(NSNotification *)notfic
{
    NSDictionary *dic = [notfic userInfo];
    NSString *imageName = [dic valueForKeyPath:@"imageName"];
    
    UIImage *image  = nil;
    if ([imageName isEqualToString:@"play"]) {
        image = [UIImage imageNamed:@"playMain.png"];
    }
    
    if ([imageName isEqualToString:@"pause"]) {
        image = [UIImage imageNamed:@"pauseMain.png"];
    }
    
    [self.playAndPauseBtn setImage:image forState:UIControlStateNormal];
}


#pragma mark - 线控

- (BOOL)canBecomeFirstResponder
{
    
    return NO;
}


- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    
    BOOL playAndPause = [[NSUserDefaults standardUserDefaults] boolForKey:@"playAndPause"];
    // 如果是运动事件类型
    if(event.type == UIEventTypeRemoteControl){
        switch (event.subtype) {
                
            //播放事件【操作：停止状态下，按耳机线控中间按钮一下】
            case UIEventSubtypeRemoteControlPlay:

                [self.playFM.moviePlayer play];
                playAndPause = YES;
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                break;
                
            //暂停事件
            case UIEventSubtypeRemoteControlTogglePlayPause:

                
                if (playAndPause) {
                    [self.playFM.moviePlayer pause];
                }else{
                    [self.playFM.moviePlayer play];
                }
                
                playAndPause = !playAndPause;
                
//                [[NSUserDefaults standardUserDefaults] setBool:playAndPause = !playAndPause forKey:@"playAndPause"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
                
                break;
            //下一曲【操作：按耳机线控中间按钮两下】
            case UIEventSubtypeRemoteControlNextTrack:

                break;
                
             //上一曲【操作：按耳机线控中间按钮三下】
            case UIEventSubtypeRemoteControlPreviousTrack:
      
                break;
                
            //快进开始【操作：按耳机线控中间按钮两下不要松开】
            case UIEventSubtypeRemoteControlBeginSeekingForward:
 
                break;
                
            //快进停止【操作：按耳机线控中间按钮两下到了快进的位置松开】
            case UIEventSubtypeRemoteControlEndSeekingForward:

                break;
            //快退开始【操作：按耳机线控中间按钮三下不要松开】
            case UIEventSubtypeRemoteControlBeginSeekingBackward:

                break;
            //快退停止【操作：按耳机线控中间按钮三下到了快退的位置松开】   
            case UIEventSubtypeRemoteControlEndSeekingBackward:

                break;
            default:
                break;
        }
        
        [self playAndPauseMusic];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // 后台播放
     [[UIApplication sharedApplication]beginBackgroundTaskWithExpirationHandler:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TTFM" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TTFM.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
