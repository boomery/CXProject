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

+ (void)loginWithBlock:(statusBlock)statusBlock
{
    [DialogHandler showDlg];
    //登录请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setLoginStatus:YES];
        [DialogHandler showSuccessWithTitle:@"登录成功" completionBlock:^{
            statusBlock(YES);
        }];
    });
}

+ (void)setLoginStatus:(BOOL)hasLogin
{
    [[NSUserDefaults standardUserDefaults] setBool:hasLogin forKey:USER_LOGIN_STATUS];
}

+ (BOOL)LoginStatus
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:USER_LOGIN_STATUS];
}

@end
