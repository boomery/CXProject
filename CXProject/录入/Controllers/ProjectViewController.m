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
#import "Risk_Progress_ViewController.h"
#import "ManagementViewController.h"
#import "SignViewController.h"
#import "UploadPhotoViewController.h"
@interface ProjectViewController ()

@end

@implementation ProjectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"录入菜单";
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
    //交付评估
//    RiskViewController *riskVC = [[RiskViewController alloc] init];
//    riskVC.title = @"风险评估";
//    [self.navigationController pushViewController:riskVC animated:YES];
    //过程评估
    Risk_Progress_ViewController *riskVC = [[Risk_Progress_ViewController alloc] init];
    riskVC.title = @"风险评估";
    [self.navigationController pushViewController:riskVC animated:YES];
}

#pragma mark - 抽取结果
- (IBAction)extractionResult:(id)sender
{
//    ExtractionResultViewController *newVC = [[ExtractionResultViewController alloc] init];
    SignViewController *newVC = [[SignViewController alloc] init];
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
- (IBAction)managementClick:(id)sender
{
    ManagementViewController *newVC = [[ManagementViewController alloc] init];
    newVC.title = @"管理行为";
    [self.navigationController pushViewController:newVC animated:YES];
}

- (IBAction)uploadPhotoClick:(id)sender
{
    UploadPhotoViewController *newVC = [[UploadPhotoViewController alloc] init];
    newVC.title = @"照片上传";
    [self.navigationController pushViewController:newVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
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
