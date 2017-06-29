//
//  GroupEvaluateViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/27.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "GroupEvaluateViewController.h"

@interface GroupEvaluateViewController ()

@end

@implementation GroupEvaluateViewController
- (void)viewDidDisappear:(BOOL)animated
{
    [MHKeyboard removeRegisterTheViewNeedMHKeyboard];
}

- (void)viewDidAppear:(BOOL)animated
{
    [MHKeyboard addRegisterTheViewNeedMHKeyboard:self.view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(upload)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)upload
{
    [SVProgressHUD showSuccessWithStatus:@"上传完成"];
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
