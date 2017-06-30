//
//  NSString+blankString.h
//  DoubleXian
//
//  Created by Andy on 15/1/13.
//  Copyright (c) 2015年andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (blankString)

+ (NSString *)stringJsonValue:(id)JsonValue;

+(BOOL)isBlankString:(NSString*)string;


//给数字字符串每隔三位添加一个逗号
+(NSString *)countNumAndChangeformat:(NSString *)num;

//判断输入空格
+(BOOL) isEmpty:(NSString *) str ;


-(BOOL) isStartWithString:(NSString *) str ;





@end
