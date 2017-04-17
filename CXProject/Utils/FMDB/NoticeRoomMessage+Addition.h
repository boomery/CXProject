//
//  NoticeRoomMessage+Addition.h
//  ACIM
//
//  Created by blue on 15-4-1.
//  Copyright (c) 2015年 ownerblood. All rights reserved.
//

#import "NoticeRoomMessage.h"

@interface NoticeRoomMessage (Addition)

+ (void)insertNoticeRoomMessageWithTitle:(NSString *)title content:(NSString *)content insertTime:(NSString *)insertTime roomID:(NSString *)roomID messageID:(NSString *)messageID userHrid:(NSString *)userHrid;

+ (BOOL)updatePictureUrlString:(NSString *)urlString withRoomID:(NSString *)roomID messageID:(NSString *)messageID userHrid:(NSString *)userHrid;

+ (BOOL)updateIsReadWithRoomID:(NSString *)roomID messageID:(NSString *)messageID userHrid:(NSString *)userHrid;

+ (NSArray *)noticeRoomMessagesWithRoomID:(NSString *)roomID userHrid:(NSString *)userHrid;

+ (NSInteger)totalNumberOfUnreadNoticeRoomMessage;
+ (NSInteger)numberOfUnreadNoticeRoomMessageWithRoomID:(NSString *)roomID;

+ (NoticeRoomMessage *)lastRoomMessageWithRoomID:(NSString *)roomID userHrid:(NSString *)userHrid;

@end
