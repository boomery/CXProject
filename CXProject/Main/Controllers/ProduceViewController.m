//
//  ProduceViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/5/25.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "ProduceViewController.h"

@interface ProduceViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ProduceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"公司简介";
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    self.navigationController.navigationBar.shadowImage = nil;
    
    
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
