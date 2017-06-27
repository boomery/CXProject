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
@interface AppDelegate () <UITabBarControllerDelegate>

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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
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
