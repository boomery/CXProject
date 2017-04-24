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
        [SVProgressHUD showErrorWithStatus:@"本地数据文件丢失"];
        return NO;
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *jsonData = [[NSData alloc] initWithContentsOfFile:strPath];
            DataProvider *sharedProvider = [self sharedProvider];
            sharedProvider.data = [self parseJsonWithString:jsonData];
        });
        return YES;
    }
}

+ (Data *)parseJsonWithString:(NSData *)jsonData
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    if (dict)
    {
        Data *data = [Data dataWithDict:dict];
        return data;
    }
    return nil;
}

+ (NSArray *)items
{
    return provider.data.events;
}
@end
