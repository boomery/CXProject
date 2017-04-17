//
//  NoticeRoomMessage.h
//  ACIM
//
//  Created by blue on 15-4-1.
//  Copyright (c) 2015年 ownerblood. All rights reserved.
//

@interface NoticeRoomMessage : NSObject

@property (nonatomic, copy) NSString *userHrid;
@property (nonatomic, copy) NSString *messageID;
@property (nonatomic, copy) NSString *roomID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *pictureUrlString;
@property (nonatomic, copy) NSString *insertTime;
@property (nonatomic, copy) NSString *isRead;

@end
