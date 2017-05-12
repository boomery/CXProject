//
//  Data.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/10.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Data : NSObject

@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *Measuretype;
@property (nonatomic, copy) NSString *houseType;
@property (nonatomic, copy) NSString *unit;

@property (nonatomic, strong) NSMutableArray *events;

@property (nonatomic, copy) NSString *key;

+ (Data *)measureDataWithDict:(NSDictionary *)dict;
+ (Data *)riskDataWithDict:(NSDictionary *)dict;

@end
