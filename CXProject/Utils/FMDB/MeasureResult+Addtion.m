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
+ (void)insertNewMeasureResult:(MeasureResult *)result
{
    FMDatabase *db = [CXDataBaseUtil database];
    if (![db open])
    {
        [db close];
        NSAssert([db open], @"数据库打开失败");
    }
    [db setShouldCacheStatements:YES];
    
    NSString *insertSql= [NSString stringWithFormat:
                          @"Insert Or Replace Into '%@' ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",
                          MEASURE_TABLE, @"projectID", @"itemName", @"subItemName", @"measureArea", @"measurePoint", @"MeasureValues", @"designValues", @"measureResult", @"mesaureIndex", result.projectID, result.itemName, result.subItemName, result.measureArea, result.measurePoint, result.measureValues,result.designValues, result.measureResult, result.mesaureIndex];
    BOOL res = [db executeUpdate:insertSql];
    if (res)
    {
        [SVProgressHUD showSuccessWithStatus:@"数据保存成功"];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"数据保存失败"];
    }
    [db close];
}

//使用了replace into 语句 现在暂时不需要判断是否已经存在
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
                         @"select *from %@ where projectID = '%@' and itemName = '%@' and subItemName = '%@' and mesaureIndex = '%@'",MEASURE_TABLE,result.projectID,result.itemName,result.subItemName,result.mesaureIndex];
    FMResultSet *resultSet = [db executeQuery:querySql];
    while ([resultSet next])
    {
        isExist = YES;
    }
    [resultSet close];
    return isExist;
}
@end
