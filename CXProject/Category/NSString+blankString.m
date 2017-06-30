//
//  NSString+blankString.m
//  DoubleXian
//
//  Created by Andy on 15/1/13.
//  Copyright (c) 2015年 andy. All rights reserved.
//

#import "NSString+blankString.h"

@implementation NSString (blankString)


+ (NSString *)stringJsonValue:(id)JsonValue
{
    NSString *string = nil;
    if (JsonValue == [NSNull null])
    {
        string = nil;
    }
    else
    {
        if ([JsonValue isKindOfClass:[NSString class]])
        {
            string = JsonValue;
        }
        else if ([JsonValue isKindOfClass:[NSNumber class]])
        {
            string = [JsonValue stringValue];
        }
    }
    return string;
}

+(BOOL)isBlankString:(NSString*)string
{
    if (string==nil||string==NULL)
    {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    
    //去掉前后空格,判断length是否为空
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        return YES;
    }
    
    if ([string isEqualToString:@"(null)"]||[string isEqualToString:@"null"]||[string isEqualToString:@"<null>"])
    {
        return YES;
    }
    return NO;
}

+(NSString *)countNumAndChangeformat:(NSString *)num{
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3)
    {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}

+(BOOL) isEmpty:(NSString *) str {
    
    if (!str)
    {
        return true;
    }
    else
    {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}


-(BOOL) isStartWithString:(NSString *) str
{
    NSRange range1 = NSMakeRange(0, str.length);//NSMakeRange这个函数的作用是从第0位开始计算，长度为字符串的长度
    NSString * str2 =[self substringWithRange:range1];
    
    if ([str isEqualToString:str2]) {
        return YES;
    }else{
        return NO;
    }
}

@end
