//
//  Photo+Addtion.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/5.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "Photo+Addtion.h"
#import "CXDataBaseUtil.h"
#import "FileManager.h"
@implementation Photo (Addtion)
+ (void)insertNewPhoto:(Photo *)photo
{
    FMDatabase *db = [CXDataBaseUtil database];
    if (![db open])
    {
        [db close];
        NSAssert([db open], @"数据库打开失败");
    }
    [db setShouldCacheStatements:YES];
    
    NSString *insertSql= [NSString stringWithFormat:
                          @"Insert Or Replace Into '%@' VALUES ('%@', '%@', '%@', '%@','%@', '%@', '%@', '%@', '%@', '%@', '%@')",
                          [CXDataBaseUtil riskProgressTableName], photo.projectID, photo.photoName, photo.save_time, photo.place, photo.kind, photo.item, photo.subItem, photo.subItem2, photo.subItem3,photo.responsibility, photo.responsibility];
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

+ (NSMutableArray *)unsortedPhotosForProjectID:(NSString *)projectID kind:(NSString *)kind
{
    NSMutableArray *photosArray = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [CXDataBaseUtil database];
    if (![db open])
    {
        [db close];
        NSAssert([db open], @"数据库打开失败");
    }
    [db setShouldCacheStatements:YES];
    
    NSString *querySql= [NSString stringWithFormat:
                         @"select *from %@ where projectID = '%@' and kind = '%@' and item = '' and subItem = '' and subItem2 = '' and subItem3 = ''",[CXDataBaseUtil riskProgressTableName],projectID, kind];
    FMResultSet *res = [db executeQuery:querySql];
    while ([res next])
    {
        Photo *photo = [[Photo alloc] init];
        photo.projectID = [res stringForColumn:@"projectID"];
        photo.photoName = [res stringForColumn:@"photoName"];
        photo.save_time = [res stringForColumn:@"save_time"];
        photo.place = [res stringForColumn:@"place"];
        photo.photoFilePath = [FileManager imagePathForName:[res stringForColumn:@"photoName"]];
        photo.kind = [res stringForColumn:@"kind"];
        photo.item = [res stringForColumn:@"item"];
        photo.subItem = [res stringForColumn:@"subItem"];
        photo.subItem2 = [res stringForColumn:@"subItem2"];
        photo.subItem3 = [res stringForColumn:@"subItem3"];
        photo.responsibility = [res stringForColumn:@"responsibility"];
        photo.repair_time = [res stringForColumn:@"repair_time"];
        [photosArray addObject:photo];
    }
    [res close];
    [db close];
    return photosArray;
}

+ (void)countPhotoForProjectID:(NSString *)projectID kind:(NSString *)kind item:(NSString *)item completionBlock:(void(^)(NSString *index))block
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[CXDataBaseUtil getDatabasePath]];
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *querySql=  [NSString stringWithFormat:
                              @"select count(*) as 'count' from '%@' where projectID='%@' and kind == '%@' and item = '%@'",[CXDataBaseUtil riskProgressTableName], projectID, kind, item];
        FMResultSet *res = [db executeQuery:querySql];
        while ([res next])
        {
            NSString *count = [res stringForColumn:@"count"];
            block(count);
        }
        [res close];
    }];
}

+ (void)photosForProjectID:(NSString *)projectID item:(NSString *)item subItem:(NSString *)subItem completionBlock:(void(^)(NSMutableArray *resultArray))block
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[CXDataBaseUtil getDatabasePath]];
    [queue inDatabase:^(FMDatabase *db) {
        NSMutableArray *photosArray = [[NSMutableArray alloc] init];

        NSString *querySql= [NSString stringWithFormat:
                             @"select *from %@ where projectID = '%@' and item = '%@' and subItem = '%@'",[CXDataBaseUtil riskProgressTableName],projectID, item, subItem];
        FMResultSet *res = [db executeQuery:querySql];
        while ([res next])
        {
            Photo *photo = [[Photo alloc] init];
            photo.projectID = [res stringForColumn:@"projectID"];
            photo.photoName = [res stringForColumn:@"photoName"];
            photo.save_time = [res stringForColumn:@"save_time"];
            photo.place = [res stringForColumn:@"place"];
            photo.photoFilePath = [FileManager imagePathForName:[res stringForColumn:@"photoName"]];
            photo.kind = [res stringForColumn:@"kind"];
            photo.item = [res stringForColumn:@"item"];
            photo.subItem = [res stringForColumn:@"subItem"];
            photo.subItem2 = [res stringForColumn:@"subItem2"];
            photo.subItem3 = [res stringForColumn:@"subItem3"];
            photo.responsibility = [res stringForColumn:@"responsibility"];
            photo.repair_time = [res stringForColumn:@"repair_time"];
            [photosArray addObject:photo];
        }
        [res close];
        block(photosArray);
    }];
}

+ (NSString *)textKindForIndex:(NSInteger)index
{
    NSArray *array = @[@"安全文明", @"质量风险", @"优秀照片"];
    return array[index];
}
@end
