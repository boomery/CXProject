//
//  RiskResult+Addition.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/5/16.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "RiskResult+Addition.h"
#import "CXDataBaseUtil.h"
@implementation RiskResult (Addition)

+ (RiskResult *)resultForProjectID:(NSString *)projectID itemName:(NSString *)itemName subItemName:(NSString *)subItemName
{
    FMDatabase *db = [CXDataBaseUtil database];
    if (![db open])
    {
        [db close];
        NSAssert([db open], @"数据库打开失败");
    }
    [db setShouldCacheStatements:YES];
    
    NSString *querySql= [NSString stringWithFormat:
                         @"select distinct *from %@ where projectID = '%@' and itemName = '%@' and subItemName = '%@'",[CXDataBaseUtil riskTableName],projectID,itemName,subItemName];
    FMResultSet *res = [db executeQuery:querySql];
    RiskResult *result = nil;
    while ([res next])
    {
        result = [[RiskResult alloc] init];
        result.projectID = [res stringForColumn:@"projectID"];
        result.itemName = [res stringForColumn:@"itemName"];
        result.subItemName = [res stringForColumn:@"subItemName"];
        result.score = [res stringForColumn:@"score"];
        result.level = [res stringForColumn:@"level"];
        result.result = [res stringForColumn:@"result"];
        result.responsibility = [res stringForColumn:@"responsibility"];
        result.photoName = [res stringForColumn:@"photoName"];
    }
    [res close];
    [db close];
    return result;
}

@end
