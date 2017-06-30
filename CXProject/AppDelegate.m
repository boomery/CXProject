//
//  AppDelegate.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/3/22.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "MainViewController.h"
#import "CountViewController.h"
#import "ProjecListtViewController.h"
#import "MineViewController.h"
#import "LoginViewController.h"
#import "CXDataBaseUtil.h"

// 引 JPush功能所需头 件
#import "JPUSHService.h"
// iOS10注册APNs所需头 件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate () <UITabBarControllerDelegate, JPUSHRegisterDelegate>

@property (nonatomic, strong) BaseNavigationController *logNav;

@end

@implementation AppDelegate

//忽略过期方法警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.backgroundColor = [UIColor whiteColor];
    [window makeKeyAndVisible];
    self.window = window;
    [self setupControllers];
    [self setTheme];
    [self initData];
    [self initJPush];

    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification)
    {
        // 程序完全退出时，点击通知，添加需求。。。
    }
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];  // 这里是没有advertisingIdentifier的情况，有的话，大家在自行添加
    return YES;
}

- (void)initData
{
    [DataProvider loadDataWithJsonFileName:@"Measure"];
    [DataProvider loadDataWithJsonFileName:@"Risk"];
    [DataProvider loadDataWithJsonFileName:@"Risk_Progress"];
    //初始化用户单例
    [User sharedUser];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [CXDataBaseUtil creatTable];
    });
    //    [NetworkAPI downloadProjectItemWithProjectID:nil showHUD:YES successBlock:^(id returnData) {
    //
    //    } failureBlock:^(NSError *error) {
    //
    //    }];
}

- (void)setTheme
{
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1.00]];
    [SVProgressHUD setForegroundColor:THEME_COLOR];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@"smile"]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    //背景颜色
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:1 green:0.34 blue:0.31 alpha:1.00]];
    //标题颜色
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:THEME_COLOR};
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    //左右侧字体颜色
    [[UINavigationBar appearance] setTintColor:THEME_COLOR];
    [UINavigationBar appearance].barStyle = UIBaselineAdjustmentNone;
    [UINavigationBar appearance].translucent = NO;
    
    [[UITabBar appearance] setBarTintColor:THEME_COLOR];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0.90 green:0.20 blue:0.14 alpha:1.00]];
}

- (void)setupControllers
{
    MainViewController *mainVC = [[MainViewController alloc] init];
    //    mainVC.title = @"首页";
    BaseNavigationController *mainNav = [[BaseNavigationController alloc] initWithRootViewController:mainVC];
    mainNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[[UIImage imageNamed:@"home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImage imageNamed:@"home_selected"]];
    
    ProjecListtViewController *inputVC = [[ProjecListtViewController alloc] init];
    inputVC.title = @"数据录入";
    BaseNavigationController *inputNav = [[BaseNavigationController alloc] initWithRootViewController:inputVC];
    inputNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"数据录入" image:[[UIImage imageNamed:@"measure"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImage imageNamed:@"measure_selected"]];
    
    CountViewController *countVC = [[CountViewController alloc] init];
    countVC.title = @"数据查询";
    BaseNavigationController *countNav = [[BaseNavigationController alloc] initWithRootViewController:countVC];
    countNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"数据查询" image:[[UIImage imageNamed:@"search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImage imageNamed:@"search_selected"]];
    
    MineViewController *mineVC = [[MineViewController alloc] init];
    //    mineVC.title = @"我的";
    BaseNavigationController *mineNav = [[BaseNavigationController alloc] initWithRootViewController:mineVC];
    
    mineNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[[UIImage imageNamed:@"my"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[UIImage imageNamed:@"my_selected"]];
    
    TabBarController *tab = [[TabBarController alloc] init];
    tab.delegate = self;
    tab.viewControllers = @[mainNav, countNav, inputNav, mineNav];
    self.window.rootViewController = tab;
    _tab = tab;
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    BOOL hasLogin = [User userLoginStatus];
    BaseNavigationController *nav = (BaseNavigationController *)viewController;
    if (!hasLogin && ![nav.topViewController isKindOfClass:[MainViewController class]])
    {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        BaseNavigationController *logNav = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        loginVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissLogin)];
        [_tab presentViewController:logNav animated:YES completion:nil];
        _logNav = logNav;
        return NO;
    }
    //点击当前选中页面无操作
    if (viewController == tabBarController.selectedViewController)
    {
        return NO;
    }
    return YES;
}

- (void)dismissLogin
{
    [_logNav dismissViewControllerAnimated:self completion:nil];
}

#pragma mark - 推送相关
- (void)initJPush
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate
// ios 10 support 处于前台时接收到通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        [JPUSHService handleRemoteNotification:userInfo];
        // 添加各种需求。。。。。
    }
    completionHandler(UNNotificationPresentationOptionAlert);
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    // 处于前台时，添加需求，一般是弹出alert跟用户进行交互，这时候completionHandler(UNNotificationPresentationOptionAlert)这句话就可以注释掉了，这句话是系统的alert，显示在app的顶部，
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        [JPUSHService handleRemoteNotification:userInfo];
        //推送打开
        if (userInfo)
        {
            // 取得 APNs 标准信息内容
            //            NSDictionary *aps = [userInfo valueForKey:@"aps"];
            //            NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
            //            NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
            //            NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
            
            // 添加各种需求。。。。。
            
            [JPUSHService handleRemoteNotification:userInfo];
            completionHandler(UIBackgroundFetchResultNewData);
        }
        completionHandler();  // 系统要求执行这个方法
    }
}

// Required, iOS 7 Support
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        // 处于前台时 ，添加各种需求代码。。。。
        
    }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        // app 处于后台 ，添加各种需求
    }
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[UIApplication alloc] setApplicationIconBadgeNumber:0];
}

// 点击之后badge清零
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
    [[UNUserNotificationCenter alloc] removeAllPendingNotificationRequests];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"CXProject"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
