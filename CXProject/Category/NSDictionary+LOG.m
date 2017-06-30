//
//  NSDictionary+LOG.m
//  Test
//
//  Created by zhangchaoxin on 2017/4/7.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "NSDictionary+LOG.h"


@implementation NSDictionary (LOG)

- (NSString *)descriptionWithLocale:(id)locale
{
    // 1.定义一个可变的字符串, 保存拼接结果
    NSMutableString *strM = [NSMutableString string];
    [strM appendString:@"{\n"];
    // 2.迭代字典中所有的key/value, 将这些值拼接到字符串中
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSDictionary class]])
        {
            [obj descriptionWithLocale:nil];
        }
        else
        {
            [strM appendFormat:@"\t%@ = %@,\n", key, obj];
        }
    }];
    [strM appendString:@"}"];
    
    // 删除最后一个逗号
    if (self.allKeys.count > 0) {
        NSRange range = [strM rangeOfString:@"," options:NSBackwardsSearch];
        [strM deleteCharactersInRange:range];
    }
    
    // 3.返回拼接好的字符串
    return strM;
}


@end
