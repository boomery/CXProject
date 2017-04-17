//
//  MeasureResult+Addtion.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/17.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "MeasureResult+Addtion.h"
#import "CXDataBaseUtil.h"
@implementation MeasureResult (Addtion)
+ (void)insertMeasureResultWithProjectID:(NSString *)projectID
                                itemName:(NSString *)itemName
                             subItemName:(NSString *)subItemName
                             measureArea:(NSString *)measureArea
                            measurePoint:(NSString *)measurePoint
                           MeasureValues:(NSString *)MeasureValues
                            designValues:(NSString *)designValues
                           measureResult:(NSString *)measureResult
                            mesaureIndex:(NSString *)mesaureIndex
{
    FMDatabase *db = [CXDataBaseUtil database];
    if (![db open])
    {
        [db close];
        NSAssert([db open], @"数据库打开失败");
    }
    [db setShouldCacheStatements:YES];
    MeasureResult *result = [[MeasureResult alloc] init];
    result.projectID = projectID;
    result.itemName = itemName;
    result.subItemName = subItemName;
    if (![self isExistThisMeaureResult:result])
    {
        NSString *insertSql= [NSString stringWithFormat:
                              @"INSERT INTO '%@' ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",
                              MEASURE_TABLE, @"projectID", @"itemName", @"subItemName", @"measureArea", @"measurePoint", @"MeasureValues", @"designValues", @"measureResult", @"mesaureIndex", projectID, itemName, subItemName, measureArea, measurePoint, MeasureValues,designValues, measureResult, mesaureIndex];
        BOOL res = [db executeUpdate:insertSql];
        if (res)
        {
            NSLog(@"数据插入成功");
        }
        else
        {
            NSLog(@"数据插入失败");
        }
        [db close];
    }
    else
    {
        //        [self updateMessageWithTitle:title content:content insertTime:insertTime roomID:roomID messageID:messageID userHrid:userHrid];
    }
}

#pragma mark - 判断如果收到的是已经存储过的录入点
+ (BOOL)isExistThisMeaureResult:(MeasureResult *)result
{
    BOOL isExist = NO;
    FMDatabase *db = [CXDataBaseUtil database];
    if (![db open])
    {
        [db close];
        NSAssert([db open], @"数据库打开失败");
    }
    [db setShouldCacheStatements:YES];
    NSString *querySql= [NSString stringWithFormat:
                         @"select *from %@ where projectID = '%@' and itemName = '%@' and subItemName = '%@'",MEASURE_TABLE,result.projectID,result.itemName,result.subItemName];
    FMResultSet *resultSet = [db executeQuery:querySql];
    while ([resultSet next])
    {
        isExist = YES;
    }
    [resultSet close];
    return isExist;
}
@end
