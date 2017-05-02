//
//  GroupEvaluateViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/27.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "GroupEvaluateViewController.h"

@interface GroupEvaluateViewController ()
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;

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
    UIButton *uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadButton.frame = CGRectMake(0, 0, 40, 40);
    uploadButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [uploadButton addTarget:self action:@selector(upload) forControlEvents:UIControlEventTouchUpInside];
    [uploadButton setImage:[UIImage imageNamed:@"upload"] forState:UIControlStateNormal];
    [uploadButton setTitle:@"上传" forState:UIControlStateNormal];
    [uploadButton setTitleEdgeInsets:UIEdgeInsetsMake(25, -10, 0, -10)];
    [uploadButton setImageEdgeInsets:UIEdgeInsetsMake(5, 20, 15, -10)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:uploadButton];
    self.navigationItem.rightBarButtonItem = item;

    NSArray *array = @[_view1, _view2, _view3, _view4];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = obj;
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [LINE_COLOR CGColor];
    }];
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
