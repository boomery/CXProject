//
//  Event.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/11.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

//分项名称
@property (nonatomic,copy) NSString *name;
//是否有设计值
@property (nonatomic,assign) BOOL needDesgin;
@property (nonatomic,assign) NSInteger design;

//需要的录入点数
@property (nonatomic,assign) NSInteger measurePoint;

//是否有规定值
@property (nonatomic,assign) BOOL needStandard;
@property (nonatomic,assign) NSInteger standard;

//存放最小值或最大值
@property (nonatomic,assign) CGFloat min;
@property (nonatomic,assign) CGFloat max;

//选择条件
@property (nonatomic,copy) NSString *condition;
//有选择条件时的第二标准
@property (nonatomic,assign) CGFloat max2;

//文字描述标准
@property (nonatomic, copy) NSString *textStandard;

//合格点计算说明
@property (nonatomic,copy) NSString *explain;

//大项里的分项
@property (nonatomic, strong) NSMutableArray *events;

@end
