//
//  NoticeRoomMessage+Addition.m
//  ACIM
//
//  Created by blue on 15-4-1.
//  Copyright (c) 2015年 ownerblood. All rights reserved.
//

#import "NoticeRoomMessage+Addition.h"
#import "CXDataBaseUtil.h"
@implementation NoticeRoomMessage (Addition)
#pragma mark - 插入一条新的公告
+ (void)insertNoticeRoomMessageWithTitle:(NSString *)title content:(NSString *)content insertTime:(NSString *)insertTime roomID:(NSString *)roomID messageID:(NSString *)messageID userHrid:(NSString *)userHrid
{
    FMDatabase *db = [CXDataBaseUtil database];
    if (![db open])
    {
        [db close];
        NSAssert([db open], @"数据库打开失败");
    }
    //(messageID TEXT PRIMARY KEY, roomID TEXT, title TEXT, content TEXT, pictureUrlString TEXT, userHrid TEXT)"
    [db setShouldCacheStatements:YES];
    if (![self isExistThisRoomID:roomID messageID:messageID userHrid:userHrid])
    {
        NSString *insertSql= [NSString stringWithFormat:
                              @"INSERT INTO '%@' ('%@', '%@', '%@', '%@', '%@','%@') VALUES ('%@', '%@', '%@', '%@', '%@','%@')",
                              MEASURE_TABLE, @"messageID", @"roomID", @"title", @"content", @"userHrid",@"insertTime",messageID,roomID,title,content,userHrid,insertTime];
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

#pragma mark - 更新同一条公告的图片地址
+ (BOOL)updatePictureUrlString:(NSString *)urlString withRoomID:(NSString *)roomID messageID:(NSString *)messageID userHrid:(NSString *)userHrid
{
    FMDatabase *db = [CXDataBaseUtil database];
    if (![db open])
    {
        [db close];
        NSAssert([db open], @"数据库打开失败");
    }
    //(messageID TEXT PRIMARY KEY, roomID TEXT, title TEXT, content TEXT, pictureUrlString TEXT, userHrid TEXT)"
    [db setShouldCacheStatements:YES];
    NSString *updateSql= [NSString stringWithFormat:
                          @"update '%@' set %@ = '%@'  where roomID = '%@' and messageID = '%@' and userHrid = '%@'",
                          MEASURE_TABLE,@"pictureUrlString",urlString,roomID,messageID,userHrid];
    BOOL res = [db executeUpdate:updateSql];
    if (res)
    {
        NSLog(@"图片数据插入成功");
    }
    else
    {
        NSLog(@"图片数据插入失败");
    }
    [db close];
    return res;
}

#pragma mark - 更新某条公告的已读状态
+ (BOOL)updateIsReadWithRoomID:(NSString *)roomID messageID:(NSString *)messageID userHrid:(NSString *)userHrid
{
    FMDatabase *db = [CXDataBaseUtil database];
    if (![db open])
    {
        [db close];
        NSAssert([db open], @"数据库打开失败");
    }
    //(messageID TEXT PRIMARY KEY, roomID TEXT, title TEXT, content TEXT, pictureUrlString TEXT, userHrid TEXT)"
    [db setShouldCacheStatements:YES];
    NSString *updateSql= [NSString stringWithFormat:
                          @"update '%@' set %@ = '%@'  where roomID = '%@' and messageID = '%@' and userHrid = '%@'",
                          MEASURE_TABLE,@"isRead",@"1",roomID,messageID,userHrid];
    BOOL res = [db executeUpdate:updateSql];
    if (res)
    {
        NSLog(@"改为已读状态成功");
    }
    else
    {
        NSLog(@"改为已读状态失败");
    }
    [db close];
    return res;
}
#pragma mark - 返回未读公告消息的总条数
//select  distinct count(messageID) from noticeRoomMessageTable where isRead = '0'
+ (NSInteger)totalNumberOfUnreadNoticeRoomMessage
{
    FMDatabase *db = [CXDataBaseUtil database];
    if (![db open])
    {
        [db close];
        NSAssert([db open], @"数据库打开失败");
    }
    //(messageID TEXT PRIMARY KEY, roomID TEXT, title TEXT, content TEXT, pictureUrlString TEXT, userHrid TEXT)"
    [db setShouldCacheStatements:YES];
    NSString *querySql= [NSString stringWithFormat:
                         @"select  distinct count(messageID) as 'count' from %@ where isRead = '0' and userHrid = '%@'",MEASURE_TABLE,@"hrid"];
    FMResultSet *result = [db executeQuery:querySql];
    while ([result next])
    {
         NSInteger count = [result intForColumn:@"count"];
        return count;
    }
    [result close];
    [db close];
    return 0;
}
#pragma mark - 返回某公告房间的未读消息数
+ (NSInteger)numberOfUnreadNoticeRoomMessageWithRoomID:(NSString *)roomID
{
    FMDatabase *db = [CXDataBaseUtil database];
    if (![db open])
    {
        [db close];
        NSAssert([db open], @"数据库打开失败");
    }
    //(messageID TEXT PRIMARY KEY, roomID TEXT, title TEXT, content TEXT, pictureUrlString TEXT, userHrid TEXT)"
    [db setShouldCacheStatements:YES];
    NSString *querySql= [NSString stringWithFormat:
                         @"select  distinct count(messageID) as 'count' from %@ where isRead = '0' and userHrid = '%@' and roomID = '%@'",MEASURE_TABLE,@"hrid",roomID];
    FMResultSet *result = [db executeQuery:querySql];
    while ([result next])
    {
        NSInteger count = [result intForColumn:@"count"];
        return count;
    }
    [result close];
    [db close];
    return 0;
}
#pragma mark - 根据公告房间和工号返回公告消息数组
+ (NSArray *)noticeRoomMessagesWithRoomID:(NSString *)roomID userHrid:(NSString *)userHrid
{
    NSMutableArray *noticeRoomMessageArray = [[NSMutableArray alloc] init];
    FMDatabase *db = [CXDataBaseUtil database];
    if (![db open])
    {
        [db close];
        NSAssert([db open], @"数据库打开失败");
    }
    //(messageID TEXT PRIMARY KEY, roomID TEXT, title TEXT, content TEXT, pictureUrlString TEXT, userHrid TEXT)"
    [db setShouldCacheStatements:YES];
    NSString *querySql= [NSString stringWithFormat:
                         @"select distinct *from %@ where roomID = '%@' and userHrid = '%@'",MEASURE_TABLE,roomID,userHrid];
    FMResultSet *result = [db executeQuery:querySql];
    while ([result next])
    {
        NoticeRoomMessage *roomMessage = [[NoticeRoomMessage alloc] init];
        roomMessage.userHrid = [result stringForColumn:@"userHrid"];
        roomMessage.messageID = [result stringForColumn:@"messageID"];
        roomMessage.roomID = [result stringForColumn:@"roomID"];
        roomMessage.title = [result stringForColumn:@"title"];
        roomMessage.content = [result stringForColumn:@"content"];
        roomMessage.pictureUrlString = [result stringForColumn:@"pictureUrlString"];
        roomMessage.insertTime = [result stringForColumn:@"insertTime"];
        roomMessage.isRead = [result stringForColumn:@"isRead"];
        [noticeRoomMessageArray addObject:roomMessage];
    }
    [result close];
    [db close];
    return noticeRoomMessageArray;
}

#pragma mark - 返回最后一条公告消息
+ (NoticeRoomMessage *)lastRoomMessageWithRoomID:(NSString *)roomID userHrid:(NSString *)userHrid
{
    //select *from noticeRoomMessageTable where rowid in (select max(rowid) from noticeRoomMessageTable where roomid = '测试0401')
    NoticeRoomMessage *roomMessage = nil;
    FMDatabase *db = [CXDataBaseUtil database];
    if (![db open])
    {
        [db close];
        NSAssert([db open], @"数据库打开失败");
    }
    //(messageID TEXT PRIMARY KEY, roomID TEXT, title TEXT, content TEXT, pictureUrlString TEXT, userHrid TEXT)"
    [db setShouldCacheStatements:YES];
    NSString *querySql= [NSString stringWithFormat:
                         @"select *from %@ where rowid in (select max(rowid) from %@ where roomid = '%@'and %@ = '%@')",MEASURE_TABLE,MEASURE_TABLE,roomID,@"userHrid",userHrid];
    FMResultSet *result = [db executeQuery:querySql];
    while ([result next])
    {
        roomMessage = [[NoticeRoomMessage alloc] init];
        roomMessage.userHrid = [result stringForColumn:@"userHrid"];
        roomMessage.messageID = [result stringForColumn:@"messageID"];
        roomMessage.roomID = [result stringForColumn:@"roomID"];
        roomMessage.title = [result stringForColumn:@"title"];
        roomMessage.content = [result stringForColumn:@"content"];
        roomMessage.insertTime = [result stringForColumn:@"insertTime"];
        roomMessage.pictureUrlString = [result stringForColumn:@"pictureUrlString"];
        roomMessage.isRead = [result stringForColumn:@"isRead"];
    }
    [result close];
    [db close];
    return roomMessage;
}

#pragma mark - 判断如果收到的是已经接收过的公告
+ (BOOL)isExistThisRoomID:(NSString *)roomID messageID:(NSString *)messageID userHrid:(NSString *)userHrid
{
    BOOL isExist = NO;
    FMDatabase *db = [CXDataBaseUtil database];
    if (![db open])
    {
        [db close];
        NSAssert([db open], @"数据库打开失败");
    }
    //(messageID TEXT PRIMARY KEY, roomID TEXT, title TEXT, content TEXT, pictureUrlString TEXT, userHrid TEXT)"
    [db setShouldCacheStatements:YES];
    NSString *querySql= [NSString stringWithFormat:
                         @"select *from %@ where messageID = '%@' and roomID = '%@' and userHrid = '%@'",MEASURE_TABLE,messageID,roomID,userHrid];
    FMResultSet *result = [db executeQuery:querySql];
    while ([result next])
    {
        isExist = YES;
    }
    [result close];
    return isExist;
}

#pragma mark - 被编辑后再次发出，需要再次更新内容
+ (void)updateMessageWithTitle:(NSString *)title content:(NSString *)content insertTime:(NSString *)insertTime roomID:(NSString *)roomID messageID:(NSString *)messageID userHrid:(NSString *)userHrid
{
    FMDatabase *db = [CXDataBaseUtil database];
    if (![db open])
    {
        [db close];
        NSAssert([db open], @"数据库打开失败");
    }
    //(messageID TEXT PRIMARY KEY, roomID TEXT, title TEXT, content TEXT, pictureUrlString TEXT, userHrid TEXT)"
    [db setShouldCacheStatements:YES];
    NSString *updateSql= [NSString stringWithFormat:
                          @"update '%@' set %@ = '%@',%@ = '%@',%@='%@',%@='%@'  where roomID = '%@' and messageID = '%@' and userHrid = '%@'",
                          MEASURE_TABLE,@"title",title,@"content",content,@"isRead",@"0",@"insertTime",insertTime,roomID,messageID,userHrid];
    BOOL res = [db executeUpdate:updateSql];
    if (res)
    {
        NSLog(@"数据更新成功");
    }
    else
    {
        NSLog(@"数据更新失败");
    }
    [db close];
}

@end
