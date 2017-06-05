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
@property (nonatomic, strong) Data *measureData;
@property (nonatomic, strong) Data *riskData;
@property (nonatomic, strong) Data *riskProgressData;
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

+ (BOOL)loadDataWithJsonFileName:(NSString *)name
{
    NSString *strPath = [[NSBundle mainBundle] pathForResource:name ofType:@"geojson"];
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
            if ([name isEqualToString:@"Measure"])
            {
                sharedProvider.measureData = [self parseJsonWithString:jsonData type:1];
            }
            else if([name isEqualToString:@"Risk"])
            {
                sharedProvider.riskData = [self parseJsonWithString:jsonData type:2];
            }
            else
            {
                sharedProvider.riskProgressData = [self parseJsonWithString:jsonData type:3];
            }
        });
        return YES;
    }
}

+ (Data *)parseJsonWithString:(NSData *)jsonData type:(NSInteger)type
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    if (dict)
    {
        Data *data = nil;
        if (type == 1)
        {
            data = [Data measureDataWithDict:dict];
        }
        else if (type == 2)
        {
            data = [Data riskDataWithDict:dict];
        }
        else if (type == 3)
        {
            data = [Data riskDataWithDict:dict];
        }
        return data;
    }
    return nil;
}

+ (NSArray *)measureItems
{
    return provider.measureData.events;
}
+ (NSArray *)riskItems
{
    return provider.riskData.events;
}
+ (NSArray *)riskProgressItems
{
    return provider.riskProgressData.events;
}
@end
