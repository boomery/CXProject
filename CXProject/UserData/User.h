//
//  User.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/3/28.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^statusBlock)(BOOL loginStatus);
@interface User : NSObject

+ (instancetype)sharedUser;

+ (BOOL)LoginStatus;

+ (void)loginWithBlock:(statusBlock)statusBlock;

@end
