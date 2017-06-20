//
//  LoginViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/3/28.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "LoginViewController.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UIView *passView;
@property (weak, nonatomic) IBOutlet UIButton *remberButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _userView.layer.borderWidth = 0.5;
    _userView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _userView.layer.cornerRadius = 5;
    _passView.layer.borderWidth = 0.5;
    _passView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _passView.layer.cornerRadius = 5;
    
    self.title = @"快速登录";
    
    [_nameTextField addTarget:self action:@selector(pressReturn) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_passwordTextField addTarget:self action:@selector(pressReturn) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 0, 15, 15);
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)cancelButtonClick:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pressReturn
{
    [self.view endEditing:YES];
}
//忽略过期方法警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (IBAction)login:(id)sender
{
    if ([self isValidLogin])
    {
        //执行登录
        [User loginWithUserName:_nameTextField.text password:_passwordTextField.text remberPassword:_remberButton.selected completionBlock:^(BOOL loginStatus) {
            if (loginStatus)
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:@"请检查用户名或密码"];
    }
}
- (IBAction)forgetPassword:(id)sender
{
    [SVProgressHUD showInfoWithStatus:@"请联系管理员找回"];
}

- (IBAction)viewPassword:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected)
    {
        _imageView.image = [UIImage imageNamed:@"eye_selected"];
    }
    else
    {
        _imageView.image = [UIImage imageNamed:@"eye_"];
    }
    _passwordTextField.secureTextEntry = !sender.selected;
}

- (IBAction)remberPassword:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

#pragma clang diagnostic pop
- (BOOL)isValidLogin
{
    if (_nameTextField.text.length == 0 || _passwordTextField.text.length == 0)
    {
        return NO;
    }
    return YES;
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
