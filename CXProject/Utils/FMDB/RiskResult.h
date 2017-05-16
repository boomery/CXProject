//
//  RiskResult.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/5/16.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RiskResult : NSObject

@property (nonatomic, copy) NSString *projectID;
@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *subItemName;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *result;
@property (nonatomic, copy) NSString *responsibility;
@property (nonatomic, copy) NSString *photoName;

@end
