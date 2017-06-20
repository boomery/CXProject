//
//  User.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/3/28.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "User.h"
#define USER_LOGIN_STATUS @"USER_LOGIN_STATUS"
#define USER_IS_OURSTAFF @"USER_IS_OURSTAFF"

@interface User ()
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL isOurStaff;
@property (nonatomic, assign) BOOL loginStatus;
@property (nonatomic, strong) Project *editingProject;
@end
static User *sharedUser = nil;
@implementation User
+ (instancetype)sharedUser
{
    static dispatch_once_t onceToken;
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
+ (void)loginWithUserName:(NSString *)name password:(NSString *)password remberPassword:(BOOL)remberPassword completionBlock:(completion)completionBlock
{
    [NetworkAPI loginWithUserName:name password:password showHUD:YES successBlock:^(id returnData) {
        [SVProgressHUD dismissWithCompletion:^{
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            if (remberPassword)
            {
                [self setUserLoginStatus:YES];
            }
            [self setuserIsOurStaff:YES];
            sharedUser.loginStatus = YES;
            sharedUser.isOurStaff = YES;
            
            completionBlock(YES);
        }];
    } failureBlock:^(NSError *error) {
        [SVProgressHUD dismissWithCompletion:^{
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            completionBlock(NO);
            
        }];
    }];
}

#pragma mark - 退出登录
+ (void)logoutWithBlock:(completion)completionBlock
{
    [SVProgressHUD showWithStatus:@"退出登录"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismissWithCompletion:^{
            [self setUserLoginStatus:NO];
            [self setuserIsOurStaff:NO];
            
            sharedUser.loginStatus = NO;
            sharedUser.isOurStaff = NO;
            
            completionBlock(YES);
        }];
    });
}

+ (BOOL)isOurStaff
{
    return sharedUser.isOurStaff || [self userIsOurStaff];
}

#pragma mark - 用户信息
+ (BOOL)userIsOurStaff
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:USER_IS_OURSTAFF] || sharedUser.isOurStaff;
}

+ (void)setuserIsOurStaff:(BOOL)isOurStaff
{
    [[NSUserDefaults standardUserDefaults] setBool:isOurStaff forKey:USER_IS_OURSTAFF];
}

#pragma mark - 用户登录状态
+ (BOOL)userLoginStatus
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:USER_LOGIN_STATUS] || sharedUser.loginStatus;
}

+ (void)setUserLoginStatus:(BOOL)hasLogin
{
    [[NSUserDefaults standardUserDefaults] setBool:hasLogin forKey:USER_LOGIN_STATUS];
}

#define KEY_PROJECT_LIST @"projectList"

+ (NSMutableArray *)projectList
{
    NSMutableArray *listArray = [[NSMutableArray alloc] init];
    
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSArray *projectArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentPath error:nil];
    [projectArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]])
        {
            NSData *data = [[NSMutableData alloc] initWithContentsOfFile:[documentPath stringByAppendingPathComponent:obj]];
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            Project *project = [unarchiver decodeObjectForKey:KEY_PROJECT_LIST];
            [unarchiver finishDecoding];
            if (project)
            {
                [listArray addObject:project];
            }
        }
    }];
    return listArray;
}
+ (void)saveProject:(Project *)project
{
    if (!project.fileName)
    {
        project.fileName = [self fileName];
    }
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:project forKey:KEY_PROJECT_LIST];
    [archiver finishEncoding];
    NSError *error = nil;
    NSString *filePath = [self filePathForFileName:project.fileName];
    if ([data writeToFile:filePath options:NSDataWritingAtomic error:&error
         ])
    {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:error.description];
    }
}

+ (NSString *)filePathForFileName:(NSString *)fileName
{
    //documentPath 模拟器中运行后会发生变动，因此每次动态获取路径
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
    return filePath;
}

+ (NSString *)fileName
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH_mm_ss"];
    NSString *dateString = [formatter stringFromDate:date];
    NSString *fileName = [NSString stringWithFormat:@"project_create_at_%@",dateString];
    return fileName;
}

+ (void)setEditingProject:(Project *)project
{
    sharedUser.editingProject = project;
}
+ (Project *)editingProject
{
    return sharedUser.editingProject;
}
@end
