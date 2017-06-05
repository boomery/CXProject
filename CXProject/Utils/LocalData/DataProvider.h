//
//  DataProvider.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/10.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataProvider : NSObject

+ (instancetype)sharedProvider;

+ (BOOL)loadDataWithJsonFileName:(NSString *)name;

//实测实量项目
+ (NSArray *)measureItems;
//交付风险评估项目
+ (NSArray *)riskItems;
//过程风险评估项目
+ (NSArray *)riskProgressItems;
@end
