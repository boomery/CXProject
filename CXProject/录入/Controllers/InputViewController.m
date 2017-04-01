//
//  InputViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/3/28.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "InputViewController.h"
#import "PhotoViewController.h"
#import "NewProjectViewController.h"
@interface InputViewController ()

@end

@implementation InputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)newProject:(id)sender
{
    NewProjectViewController *newVC = [[NewProjectViewController alloc] init];
    newVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newVC animated:YES];
}
- (IBAction)photobuttonClicked:(id)sender
{
    PhotoViewController *photoVC = [[PhotoViewController alloc] init];
    photoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:photoVC animated:YES];
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
