//
//  AppDelegate.m
//  Moluren
//
//  Created by tcl-macpro on 14-10-12.
//  Copyright (c) 2014年 com.teamdongqin. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
#import "SharedSingleConfig.h"
#import "NewLanuchViewController.h"
#import "LanuchViewController.h"
#import "MolurenMainViewController.h"
#import "MolurenHistoryViewController.h"
#import "MolurenSettingViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) Reachability  *reach;

@property (nonatomic, strong) UIWindow * statusWindow;
@property (nonatomic, strong) UILabel * statusLabel;

- (void) dismissStatus;

@end

@implementation AppDelegate

// MyAppDelegate.m
- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable) {
        [SharedSingleConfig getSharedSingleConfig].networkIsOk = NO;
        /*UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"AppName"
                                                        message:@"NotReachable"
                                                       delegate:nil
                                              cancelButtonTitle:@"YES" otherButtonTitles:nil];*/
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"陌路人" message:@"亲， 貌似没有网络了， 请检查下网络设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
        [SharedSingleConfig getSharedSingleConfig].networkIsOk = YES;
    }
}
                            


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    
    _reach = [Reachability reachabilityWithHostname:@"www.moluren.net"];
    // Tell the reachability that we DON'T want to be reachable on 3G/EDGE/CDMA
    _reach.reachableOnWWAN = YES;
    
    // Here we set up a NSNotification observer. The Reachability that caused the notification
    // is passed in the object parameter
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    [_reach startNotifier];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //[application setApplicationIconBadgeNumber:0];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        // 这里判断是否第一次
        // 启动页面
        NewLanuchViewController *lanuchVC = [[NewLanuchViewController alloc] init];
        self.window.rootViewController = lanuchVC;
        
    }else{
        LanuchViewController *lanuchVC = [[LanuchViewController alloc] init];
        self.window.rootViewController = lanuchVC;
        [self performSelector:@selector(enterMainView) withObject:nil afterDelay:2];
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)enterMainView{
    UIViewController *viewController1, *viewController2 , *viewController3;
    
    viewController1 = [[MolurenMainViewController alloc] initWithNibName:nil bundle:nil];
    viewController1.title = @"Main";
    
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"开始聊天" image:nil tag:1];
    /*UITabBarItem *item1 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:1];*/
    [item1 setFinishedSelectedImage:[UIImage imageNamed:@"First_pressed"]
        withFinishedUnselectedImage:[UIImage imageNamed:@"First"]];
    viewController1.tabBarItem = item1;
    //viewController1.hidesBottomBarWhenPushed = YES;
    
    UINavigationController *chatNavigation = [[UINavigationController alloc] initWithRootViewController:viewController1];
    chatNavigation.navigationBarHidden = YES;
    
    viewController2 = [[MolurenHistoryViewController alloc] initWithNibName:nil bundle:nil];
    viewController2.title = @"History";
    
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"聊天记录" image:nil tag:2];
    [item2 setFinishedSelectedImage:[UIImage imageNamed:@"Second_pressed"]
        withFinishedUnselectedImage:[UIImage imageNamed:@"Second"]];
    viewController2.tabBarItem = item2;
    UINavigationController *historyNavigation = [[UINavigationController alloc] initWithRootViewController:viewController2];
    historyNavigation.navigationBarHidden = YES;
    
    viewController3 = [[MolurenSettingViewController alloc] initWithNibName:nil bundle:nil];
    viewController3.title = @"Setting";
    
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:@"进入设置" image:nil tag:3];
    /*UITabBarItem *item2 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:2];*/
    [item3 setFinishedSelectedImage:[UIImage imageNamed:@"Second_pressed"]
        withFinishedUnselectedImage:[UIImage imageNamed:@"Second"]];
    viewController3.tabBarItem = item3;
    UINavigationController *settingNavigation = [[UINavigationController alloc] initWithRootViewController:viewController3];
    settingNavigation.navigationBarHidden = YES;
    
    //self.tabBarController = [[UITabBarController alloc] init];
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    //self.tabBarController.delegate = self;
    //self.tabBarController.viewControllers = [NSArray arrayWithObjects:chatNavigation, settingNavigation, nil];
    tabBarController.viewControllers = @[chatNavigation,historyNavigation,settingNavigation];
    //self.tabBarController.navigationController = chatNavigation;
    
    
    self.window.rootViewController = tabBarController;
    
}

/**
 * @brief 在状态栏显示 一些Log
 *
 * @param string 需要显示的内容
 * @param duration  需要显示多长时间
 */

+ (void) showStatusWithText:(NSString *) string duration:(NSTimeInterval) duration {
    
    AppDelegate * delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    delegate.statusLabel.text = string;
    [delegate.statusLabel sizeToFit];
    CGRect rect = [UIApplication sharedApplication].statusBarFrame;
    CGFloat width = delegate.statusLabel.frame.size.width;
    CGFloat height = rect.size.height;
    rect.origin.x = rect.size.width - width - 5;
    rect.size.width = width;
    delegate.statusWindow.frame = rect;
    delegate.statusLabel.frame = CGRectMake(0, 0, width, height);
    
    if (duration < 1.0) {
        duration = 1.0;
    }
    if (duration > 4.0) {
        duration = 4.0;
    }
    [delegate performSelector:@selector(dismissStatus) withObject:nil afterDelay:duration];
}

/**
 * @brief 干掉状态栏文字
 */

- (void) dismissStatus {
    CGRect rect = self.statusWindow.frame;
    rect.origin.y -= rect.size.height;
    [UIView animateWithDuration:0.5 animations:^{
        self.statusWindow.frame = rect;
    }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
