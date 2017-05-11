//
//  ProjectViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/10.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "ProjectViewController.h"
#import "MeasureViewController.h"
#import "RiskViewController.h"
#import "NewProjectViewController.h"
#import "ExtractionResultViewController.h"
#import "GroupEvaluateViewController.h"
@interface ProjectViewController ()

@end

@implementation ProjectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"录入菜单";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(upload)];
    self.navigationItem.rightBarButtonItem = item;
    // Do any additional setup after loading the view from its nib.
}
- (void)upload
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"项目完成后无法修改" message:@"确定完成吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD showSuccessWithStatus:@"项目已经完成"];
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
   
}
#pragma mark - 实测实量
- (IBAction)measure:(id)sender
{
    MeasureViewController *measureVC = [[MeasureViewController alloc] init];
    measureVC.title = @"实测实量";
    [self.navigationController pushViewController:measureVC animated:YES];
}

#pragma mark - 风险评估
- (IBAction)riskEvaluate:(id)sender
{
    RiskViewController *riskVC = [[RiskViewController alloc] init];
    riskVC.title = @"风险评估";
    [self.navigationController pushViewController:riskVC animated:YES];
}

#pragma mark - 抽取结果
- (IBAction)extractionResult:(id)sender
{
    ExtractionResultViewController *newVC = [[ExtractionResultViewController alloc] init];
    newVC.title = @"抽取结果";
    [self.navigationController pushViewController:newVC animated:YES];
}

#pragma mark - 编辑项目
- (IBAction)editProject:(id)sender
{
    NewProjectViewController *newVC = [[NewProjectViewController alloc] init];
    newVC.title = @"编辑项目";
    newVC.project = self.project;
    [self.navigationController pushViewController:newVC animated:YES];
}

#pragma mark - 团队互评
- (IBAction)groupEvaluate:(id)sender
{
    GroupEvaluateViewController *newVC = [[GroupEvaluateViewController alloc] init];
    newVC.title = @"团队互评";
    [self.navigationController pushViewController:newVC animated:YES];
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
