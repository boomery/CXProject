//
//  NSString+isValid.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/20.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "NSString+isValid.h"

@implementation NSString (isValid)

- (BOOL)isValidNumber
{
    NSString *patter = @"^[0-9]+([.]{0,1}[0-9]+){0,1}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",patter];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isValidInt
{
    NSString *patter = @"^[1-9]\\d*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",patter];
    return [predicate evaluateWithObject:self];
}
@end
