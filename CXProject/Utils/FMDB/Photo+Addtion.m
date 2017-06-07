//
//  Photo+Addtion.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/5.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "Photo+Addtion.h"
#import "CXDataBaseUtil.h"
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
                          @"Insert Or Replace Into '%@' VALUES ('%@', '%@', '%@', '%@','%@', '%@', '%@', '%@', '%@', '%@')",
                          [CXDataBaseUtil riskProgressTableName], photo.projectID, photo.photoName, photo.save_time, photo.place, photo.kind, photo.item, photo.subItem, photo.subItem2, photo.responsibility, photo.responsibility];
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

+ (NSMutableArray *)photosForProjectID:(NSString *)projectID kind:(NSString *)kind
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
                         @"select *from %@ where projectID = '%@' and kind = '%@'",[CXDataBaseUtil riskProgressTableName],projectID, kind];
    FMResultSet *res = [db executeQuery:querySql];
    while ([res next])
    {
        Photo *photo = [[Photo alloc] init];
        photo.projectID = [res stringForColumn:@"projectID"];
        photo.photoName = [res stringForColumn:@"photoName"];
        photo.save_time = [res stringForColumn:@"save_time"];
        photo.place = [res stringForColumn:@"place"];
        photo.photoFilePath = [CXDataBaseUtil imagePathForName:[res stringForColumn:@"photoName"]];
        photo.kind = [res stringForColumn:@"kind"];
        photo.item = [res stringForColumn:@"item"];
        photo.subItem = [res stringForColumn:@"subItem"];
        photo.subItem2 = [res stringForColumn:@"subItem2"];
        photo.responsibility = [res stringForColumn:@"responsibility"];
        photo.repair_time = [res stringForColumn:@"repair_time"];
        [photosArray addObject:photo];
    }
    [res close];
    [db close];
    return photosArray;
}
@end
