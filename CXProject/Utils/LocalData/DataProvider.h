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

+ (BOOL)loadData;

+ (NSArray *)items;

@end
