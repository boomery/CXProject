//
//  Project.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/1.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Project : NSObject <NSCoding>
//文件名称
@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *site;
@property (nonatomic, copy) NSString *turn;
@property (nonatomic, copy) NSString *supervisory;
@property (nonatomic, copy) NSString *measure_date;
@property (nonatomic, copy) NSString *captain;

//评估组员与施工单位
@property (nonatomic, strong) NSMutableArray *members;
@property (nonatomic, strong) NSMutableArray *builders;

//项目简介
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *chargeman;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *progress;
@property (nonatomic, copy) NSString *end_date;

@end
