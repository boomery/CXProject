//
//  DataProvider.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/10.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "DataProvider.h"
#import "Data.h"
@interface DataProvider()
@property (nonatomic, strong) Data *data;
@end

@implementation DataProvider
static DataProvider *provider = nil;
+ (instancetype)sharedProvider
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        provider  = [[DataProvider alloc] init];
    });
    return provider;
}

+ (BOOL)loadData
{
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"Measure" ofType:@"geojson"];
    if (!strPath)
    {
        [SVProgressHUD showErrorWithStatus:@"本地数据文件读取失败"];
        return NO;
    }
    else
    {
//        NSString *parseJson = [[NSString alloc] initWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
        NSData *jsonData = [[NSData alloc] initWithContentsOfFile:strPath];
        [self parseJsonWithString:jsonData];
        return YES;
    }
}

+ (Data *)parseJsonWithString:(NSData *)jsonData
{
    Data *data = [[Data alloc] init];
    id obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    return data;
}

+ (NSArray *)standardForName:(NSString *)name
{
    return nil;
}

@end
