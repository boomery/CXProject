//
//  M_ProjectViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/1.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "M_ProjectViewController.h"
#import "M_ViewFileViewController.h"
@interface M_ProjectViewController ()

@end

@implementation M_ProjectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)projectDetailButtonClick:(id)sender
{
    
}

- (IBAction)viewExcelButtonClick:(id)sender
{
    M_ViewFileViewController *vc = [[M_ViewFileViewController alloc] init];
    vc.title = @"表格查看";
    vc.fileType = @"表格";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)viewReportButtonClick:(id)sender
{
    M_ViewFileViewController *vc = [[M_ViewFileViewController alloc] init];
    vc.title = @"报告查看";
    vc.fileType = @"报告";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)reporyQuestionButtonClick:(id)sender
{
    
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
