//
//  NSString+isValid.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/20.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (isValid)

//包含整数与小数
- (BOOL)isValidNumber;

//只包含整数
- (BOOL)isValidInt;

@end
