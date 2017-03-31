//
//  TabBarController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/3/22.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "TabBarController.h"
#import "BaseNavigationController.h"
#import "CountViewController.h"
@interface TabBarController ()
@property (nonatomic, strong) UINavigationController *logNav;
@end

@implementation TabBarController

#pragma mark - override method
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)shouldAutorotate
{
    BaseNavigationController *nav = (BaseNavigationController *)self.selectedViewController;
    if ([nav isKindOfClass:[BaseNavigationController class]])
    {
        if ([nav.topViewController isKindOfClass:[CountViewController class]])
        {
            return [self.selectedViewController shouldAutorotate];
        }
    }
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    BaseNavigationController *nav = (BaseNavigationController *)self.selectedViewController;
    if ([nav isKindOfClass:[BaseNavigationController class]])
    {
        if ([nav.topViewController isKindOfClass:[CountViewController class]])
        {
            return [self.selectedViewController supportedInterfaceOrientations];
        }
    }
    return UIInterfaceOrientationMaskPortrait;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
