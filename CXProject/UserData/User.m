//
//  User.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/3/28.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#define USER_LOGIN_STATUS @"USER_LOGIN_STATUS"
#import "User.h"
@interface User ()
{
    BOOL _hasLogin;
}
@end
@implementation User
+ (instancetype)sharedUser
{
    static dispatch_once_t onceToken;
    static id sharedUser;
    dispatch_once(&onceToken, ^{
        sharedUser = [self new];
    });
    return sharedUser;
}

- (id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

#pragma mark - 登录
+ (void)loginWithBlock:(completion)completionBlock
{
    [SVProgressHUD show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismissWithCompletion:^{
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            [self setUserLoginStatus:YES];
            completionBlock(YES);
        }];
    });
}

#pragma mark - 退出登录
+ (void)logoutWithBlock:(completion)completionBlock
{
    [SVProgressHUD showWithStatus:@"退出登录"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismissWithCompletion:^{
            [self setUserLoginStatus:NO];
            completionBlock(YES);
        }];
    });
}


+ (void)setUserLoginStatus:(BOOL)hasLogin
{
    [[NSUserDefaults standardUserDefaults] setBool:hasLogin forKey:USER_LOGIN_STATUS];
}

+ (BOOL)userLoginStatus
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:USER_LOGIN_STATUS];
}

+ (BOOL)isOurStaff
{
    return YES;
}

@end
