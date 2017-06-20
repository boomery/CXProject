//
//  User.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/3/28.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Project;
typedef void(^completion)(BOOL loginStatus);
@interface User : NSObject

+ (instancetype)sharedUser;

+ (NSString *)userName;

+ (void)loginWithUserName:(NSString *)name password:(NSString *)password remberPassword:(BOOL)remberPassword completionBlock:(completion)completionBlock;

+ (void)logoutWithBlock:(completion)completionBlock;

+ (BOOL)userLoginStatus;

+ (BOOL)isOurStaff;

+ (NSMutableArray *)projectList;

+ (void)saveProject:(Project *)project;

+ (void)setEditingProject:(Project *)project;
+ (Project *)editingProject;
@end
