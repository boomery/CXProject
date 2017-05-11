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
                          @"Insert Or Replace Into '%@' VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",
                          [CXDataBaseUtil tableName], result.projectID, result.itemName, result.subItemName, result.measureArea, result.measurePoint, result.measureValues, result.designValues,result.measureResult, result.measurePlace,  result.measurePhoto, result.mesaureIndex];
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

+ (BOOL)updateMeasureAreaMeasurePointDesignValuesWithMeasureResult:(MeasureResult *)result
{
    FMDatabase *db = [CXDataBaseUtil database];
    if (![db open])
    {
        [db close];
        NSAssert([db open], @"数据库打开失败");
    }
    [db setShouldCacheStatements:YES];
    NSString *updateSql= [NSString stringWithFormat:
                          @"update '%@' set %@ = '%@',%@='%@',%@='%@'  where %@ = '%@' and %@ = '%@' and %@ = '%@'",
                          [CXDataBaseUtil tableName],@"measureArea",result.measureArea,@"measurePoint",result.measurePoint,@"designValues",result.designValues,@"projectID",result.projectID,@"itemName",result.itemName,@"subItemName",result.subItemName];
    BOOL res = [db executeUpdate:updateSql];
    if (res)
    {
        NSLog(@"分项检测区，检测点，设计值更新成功");
    }
    else
    {
        NSLog(@"分项检测区，检测点，设计值更新失败");
    }
    [db close];
    return res;
}

+ (NSMutableDictionary *)resultsForProjectID:(NSString *)projectID itemName:(NSString *)itemName subItemName:(NSString *)subItemName
{
    NSMutableDictionary *resultsDict = [[NSMutableDictionary alloc] init];
    FMDatabase *db = [CXDataBaseUtil database];
    if (![db open])
    {
        [db close];
        NSAssert([db open], @"数据库打开失败");
    }
    [db setShouldCacheStatements:YES];
    
    NSString *querySql= [NSString stringWithFormat:
                         @"select distinct *from %@ where projectID = '%@' and itemName = '%@' and subItemName = '%@'",[CXDataBaseUtil tableName],projectID,itemName,subItemName];
    FMResultSet *res = [db executeQuery:querySql];
//    NSLog(@"%@",querySql);
    while ([res next])
    {
        MeasureResult *result = [[MeasureResult alloc] init];
        result.projectID = [res stringForColumn:@"projectID"];
        result.itemName = [res stringForColumn:@"itemName"];
        result.subItemName = [res stringForColumn:@"subItemName"];
        result.measureArea = [res stringForColumn:@"measureArea"];
        result.measurePoint = [res stringForColumn:@"measurePoint"];
        result.measureValues = [res stringForColumn:@"measureValues"];
        result.designValues = [res stringForColumn:@"designValues"];
        result.measureResult = [res stringForColumn:@"measureResult"];
        result.measurePlace = [res stringForColumn:@"measurePlace"];
        result.measurePhoto = [res stringForColumn:@"measurePhoto"];
        result.mesaureIndex = [res stringForColumn:@"mesaureIndex"];
        [resultsDict setValue:result forKey:result.mesaureIndex];
    }
    [res close];
    [db close];
    return resultsDict;
}

//#pragma mark - 更新录入照片名字
//+ (BOOL)updateMeasurePhotoName:(NSString *)photoName forMeasureResult:(MeasureResult *)result
//{
//    FMDatabase *db = [CXDataBaseUtil database];
//    if (![db open])
//    {
//        [db close];
//        NSAssert([db open], @"数据库打开失败");
//    }
//    [db setShouldCacheStatements:YES];
//    NSString *updateSql= [NSString stringWithFormat:
//                          @"update '%@' set %@ = '%@' where %@ = '%@' and %@ = '%@' and %@ = '%@'",
//                          [CXDataBaseUtil tableName], @"measurePhoto", result.measurePhoto,@"projectID", result.projectID,@"itemName", result.itemName,@"subItemName", result.subItemName];
//    BOOL res = [db executeUpdate:updateSql];
//    if (res)
//    {
//        NSLog(@"分项检测区，检测点，设计值更新成功");
//    }
//    else
//    {
//        NSLog(@"分项检测区，检测点，设计值更新失败");
//    }
//    [db close];
//    return res;
//}


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
                         @"select *from %@ where projectID = '%@' and itemName = '%@' and subItemName = '%@' and mesaureIndex = '%@'",[CXDataBaseUtil tableName],result.projectID,result.itemName,result.subItemName,result.mesaureIndex];
    FMResultSet *resultSet = [db executeQuery:querySql];
    while ([resultSet next])
    {
        isExist = YES;
    }
    [resultSet close];
    return isExist;
}
@end
