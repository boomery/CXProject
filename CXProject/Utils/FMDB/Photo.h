//
//  Photo.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/5.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (nonatomic, copy) NSString *projectID;
@property (nonatomic, copy) NSString *photoName;
@property (nonatomic, copy) NSString *save_time;
@property (nonatomic, copy) NSString *place;
@property (nonatomic, copy) NSString *photoFilePath;
@property (nonatomic, copy) NSString *kind;
@property (nonatomic, copy) NSString *item;
@property (nonatomic, copy) NSString *subItem;
@property (nonatomic, copy) NSString *subItem2;
@property (nonatomic, copy) NSString *responsibility;
@property (nonatomic, copy) NSString *repair_time;

@property (nonatomic, strong) UIImage *image;

@end
