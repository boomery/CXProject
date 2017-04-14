//
//  Project.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/1.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Project : NSObject <NSCoding>

@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *site;
@property (nonatomic, copy) NSString *turn;
@property (nonatomic, strong) NSArray *supervisory;
@property (nonatomic, copy) NSString *measure_date;
@property (nonatomic, copy) NSString *captain;
@property (nonatomic, strong) NSArray *members;
@property (nonatomic, copy) NSString *builder;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *chargeman;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *progress;
@property (nonatomic, copy) NSString *end_date;

@end
