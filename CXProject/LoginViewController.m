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

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

//忽略过期方法警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (IBAction)login:(id)sender
{
    if (![self isValidLogin])
    {
        //执行登录
        [User loginWithBlock:^(BOOL loginStatus) {
            if (loginStatus)
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
    else
    {
        ALERT(@"请检查用户名或密码");
    }
}
- (IBAction)forgetPassword:(id)sender
{
    ALERT(@"请联系电话：xxxxxxx");
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
