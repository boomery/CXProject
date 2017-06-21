//
//  MeasureResult+Addtion.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/17.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "MeasureResult+Addtion.h"
#import "CXDataBaseUtil.h"
#import "Photo.h"
#import "FileManager.h"
@implementation MeasureResult (Addtion)
+ (void)deleteMeasureResult:(MeasureResult *)result
{
    FMDatabase *db = [CXDataBaseUtil database];
    if (![db open])
    {
        [db close];
        NSAssert([db open], @"数据库打开失败");
    }
    [db setShouldCacheStatements:YES];
    NSString *deleteSql= [NSString stringWithFormat:
                         @"delete from %@ where projectID = '%@' and itemName = '%@' and subItemName = '%@' and mesaureIndex = '%@'",[CXDataBaseUtil measureTableName],result.projectID,result.itemName,result.subItemName,result.mesaureIndex];
    BOOL res = [db executeUpdate:deleteSql];
    if (res)
    {
        [SVProgressHUD showSuccessWithStatus:@"数据删除成功"];
        if (result.measurePhoto.length != 0)
        {
            Photo *photo = [[Photo alloc] init];
            photo.projectID = result.projectID;
            photo.kind = @"实测实量";
            photo.photoName = result.measurePhoto;
            [[NSFileManager defaultManager] removeItemAtPath:[FileManager imagePathForPhoto:photo] error:nil];
            NSLog(@"移除旧照片");
        }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"数据删除失败"];
    }
    
}

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
                          @"Insert Or Replace Into '%@' VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",
                          [CXDataBaseUtil measureTableName], result.projectID, result.itemName, result.subItemName, result.measureArea, result.measurePoint, result.measureValues, result.designValues,result.measureResult, result.measurePlace,  result.measurePhoto, result.mesaureIndex, result.hasUpload, result.takenBy];
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
                          @"update '%@' set %@ = '%@',%@='%@' where %@ = '%@' and %@ = '%@' and %@ = '%@'",
                          [CXDataBaseUtil measureTableName],@"measureArea",result.measureArea,@"measurePoint",result.measurePoint, @"projectID",result.projectID,@"itemName",result.itemName,@"subItemName",result.subItemName];
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
    
    //初始化不及格点数，记录点数
    NSInteger qualified = 0;
    NSInteger recordedNum = 0;

    FMDatabase *db = [CXDataBaseUtil database];
    if (![db open])
    {
        [db close];
        NSAssert([db open], @"数据库打开失败");
    }
    [db setShouldCacheStatements:YES];
    
    NSString *querySql= [NSString stringWithFormat:
                         @"select distinct *from %@ where projectID = '%@' and itemName = '%@' and subItemName = '%@'",[CXDataBaseUtil measureTableName],projectID,itemName,subItemName];
    FMResultSet *res = [db executeQuery:querySql];
    while ([res next])
    {
        MeasureResult *result = [self resultForFMResultSet:res];
        [resultsDict setValue:result forKey:result.mesaureIndex];
        NSArray *results = [result.measureResult componentsSeparatedByString:@";"];
        for (NSString *str in results)
        {
            recordedNum ++;
            if ([str isEqualToString:@"0"])
            {
                qualified ++;
            }
        }
    }
    [res close];
    [db close];
    
    //在数据库查询分项记录时   更新defaults中存储的分项点数
    [[NSUserDefaults standardUserDefaults] setInteger:recordedNum forKey:RESULT_NUM_KEY];
    //设计的点数在detailMesaure界面存储
    
    //保存分项合格点
    [[NSUserDefaults standardUserDefaults] setInteger:qualified forKey:QUALIFIED_NUM_KEY];
    return resultsDict;
}

+ (NSMutableDictionary *)resultsForProjectID:(NSString *)projectID itemName:(NSString *)itemName
{
    NSMutableDictionary *resultsDict = [[NSMutableDictionary alloc] init];
    
    
    //初始化不及格点数
    NSInteger t_recordedNum = 0;
    NSInteger t_qualified = 0;
    
    FMDatabase *db = [CXDataBaseUtil database];
    if (![db open])
    {
        [db close];
        NSAssert([db open], @"数据库打开失败");
    }
    [db setShouldCacheStatements:YES];
    
    NSString *querySql= [NSString stringWithFormat:
                         @"select distinct *from %@ where projectID = '%@' and itemName = '%@'",[CXDataBaseUtil measureTableName],projectID,itemName];
    FMResultSet *res = [db executeQuery:querySql];
    while ([res next])
    {
        MeasureResult *result = [self resultForFMResultSet:res];
        [resultsDict setValue:result forKey:result.mesaureIndex];
        NSArray *results = [result.measureResult componentsSeparatedByString:@";"];
        for (NSString *str in results)
        {
            t_recordedNum ++;
            if ([str isEqualToString:@"0"])
            {
                t_qualified ++;
            }
        }
    }
    [res close];
    [db close];
    
    //在数据库查询分项记录时   更新defaults中存储的大项点数
    [[NSUserDefaults standardUserDefaults] setInteger:t_recordedNum forKey:T_RESULT_NUM_KEY];
    //设计的点数在detailMesaure界面存储
    
    //保存大项合格点
    [[NSUserDefaults standardUserDefaults] setInteger:t_qualified forKey:T_QUALIFIED_NUM_KEY];
    return resultsDict;
}

+ (MeasureResult *)resultForFMResultSet:(FMResultSet *)res
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
    result.hasUpload = [res stringForColumn:@"hasUpload"];
    result.takenBy = [res stringForColumn:@"takenBy"];
    return result;
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
//        NSLog(@"更新照片名称成功");
//    }
//    else
//    {
//        NSLog(@"更新照片名称失败");
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
                         @"select *from %@ where projectID = '%@' and itemName = '%@' and subItemName = '%@' and mesaureIndex = '%@'",[CXDataBaseUtil measureTableName],result.projectID,result.itemName,result.subItemName,result.mesaureIndex];
    FMResultSet *resultSet = [db executeQuery:querySql];
    while ([resultSet next])
    {
        isExist = YES;
    }
    [resultSet close];
    return isExist;
}

#pragma mark - 大项数据
+ (NSInteger)tNumOfResultsForProjectID:(NSString *)projectID itemName:(NSString *)itemName
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:T_RESULT_NUM_KEY];
}

+ (NSInteger)tNumOfDesignResultsForProjectID:(NSString *)projectID itemName:(NSString *)itemName
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:T_DESIGN_NUM_KEY(projectID, itemName, subItemName)];
}

+ (NSInteger)tNumOfQualifiedForProjectID:(NSString *)projectID itemName:(NSString *)itemName
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:T_QUALIFIED_NUM_KEY];
}

#pragma mark - 分项数据
+ (NSInteger)numOfResultsForProjectID:(NSString *)projectID itemName:(NSString *)itemName subItemName:(NSString *)subItemName
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:RESULT_NUM_KEY];
}

+ (NSInteger)numOfDesignResultsForProjectID:(NSString *)projectID itemName:(NSString *)itemName subItemName:(NSString *)subItemName
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:DESIGN_NUM_KEY(projectID, itemName, subItemName)];
}

+ (NSInteger)numOfQualifiedForProjectID:(NSString *)projectID itemName:(NSString *)itemName subItemName:(NSString *)subItemName
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:QUALIFIED_NUM_KEY];
}
@end
