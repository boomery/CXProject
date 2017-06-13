//
//  CXDataBaseUtil.m
//  ACIM
//
//  Created by zcx on 15/1/27.
//  Copyright (c) 2015年 ownerblood. All rights reserved.
//

#import "CXDataBaseUtil.h"
#import "FMDatabaseAdditions.h"
@implementation CXDataBaseUtil

static FMDatabase *_db = nil;
+ (FMDatabase *)database
{
    if (_db == nil)
    {
        NSLog(@"%@",[self getDatabasePath]);
        if ([self copyDatabaseToSandbox])
        {
            NSLog(@"复制数据库成功");
        }
        _db = [[FMDatabase alloc] initWithPath:[self getDatabasePath]];
    }
    
    return _db;
}

+(void)creatTable
{
    FMDatabase *db = [self database];
    
    //判断数据库是否已经打开，如果没有打开，提示失败
    if (![db open])
    {
        NSLog(@"数据库打开失败");
        return;
    }
    //为数据库设置缓存，提高查询效率
    [db setShouldCacheStatements:YES];
    
//    NSString *deleteTable = @"drop table risk_progress_table";
//    if ([db executeUpdate:deleteTable])
//    {
//        NSLog(@"删除表");
//    }
    
   	//判断数据库中是否已经存在这个表，如果不存在则创建该表
    if(![db tableExists:[CXDataBaseUtil measureTableName]])
    {
        NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE %@(projectID TEXT, itemName TEXT, subItemName TEXT,measureArea TEXT, measurePoint TEXT, measureValues TEXT, designValues TEXT, measureResult TEXT, measurePlace TEXT, measurePhoto TEXT,mesaureIndex TEXT,PRIMARY KEY(projectID, itemName,subItemName,mesaureIndex))",[CXDataBaseUtil measureTableName]];
        if ([db executeUpdate:createSql])
        {
            NSLog(@"实测实量建表成功");
        }
    }
    //判断数据库中是否已经存在这个表，如果不存在则创建该表
    if(![db tableExists:[CXDataBaseUtil riskTableName]])
    {
        NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE %@(projectID TEXT, itemName TEXT, subItemName TEXT, score TEXT, level TEXT, result TEXT, responsibility TEXT, photoName TEXT, PRIMARY KEY(projectID, itemName, subItemName, photoName))",[CXDataBaseUtil riskTableName]];
        if ([db executeUpdate:createSql])
        {
            NSLog(@"风险交付评估建表成功");
        }
    }
    if(![db tableExists:[CXDataBaseUtil riskProgressTableName]])
    {
        NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE %@(projectID TEXT, photoName TEXT, save_time TEXT, place TEXT, kind TEXT, item TEXT, subItem TEXT, subItem2 TEXT, subItem3 TEXT, responsibility TEXT, repair_time TEXT,PRIMARY KEY(projectID, photoName))",[CXDataBaseUtil riskProgressTableName]];
        if ([db executeUpdate:createSql])
        {
            NSLog(@"风险过程评估建表成功");
        }
    }
}

+ (NSString *)measureTableName
{
    return @"MEASURE_TABLE";
}
+ (NSString *)riskTableName
{
    return @"RISK_TABLE";
}
+ (NSString *)riskProgressTableName
{
    return @"RISK_PROGRESS_TABLE";
}

+ (NSString *)getDatabasePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = paths[0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"measure.sqlite"];
    return filePath;
}

//将数据库拷贝到沙盒中
+ (BOOL)copyDatabaseToSandbox
{
    NSString *filePath = [self getDatabasePath];
    
    BOOL isCopySuccess;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath])
    {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"measure" ofType:@"sqlite"];
        isCopySuccess = [fileManager copyItemAtPath:sourcePath toPath:filePath error:nil];
    }
    else
    {
        NSLog(@"数据库已存在");
        isCopySuccess = NO;
    }
    return isCopySuccess;
}
@end
