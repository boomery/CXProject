//
//  Event.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/11.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) BOOL needDesgin;
@property (nonatomic,assign) NSInteger design;

@property (nonatomic,assign) NSInteger measurePoint;
@property (nonatomic,copy) NSString *condition;

@property (nonatomic,assign) BOOL needStandard;
@property (nonatomic,assign) NSInteger standard;

@property (nonatomic,assign) NSInteger min;
@property (nonatomic,assign) NSInteger max;
@property (nonatomic,copy) NSString *explain;

@property (nonatomic, strong) NSMutableArray *events;

@end
