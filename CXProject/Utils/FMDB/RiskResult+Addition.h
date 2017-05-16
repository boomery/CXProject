//
//  RiskResult+Addition.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/5/16.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "RiskResult.h"

@interface RiskResult (Addition)

+ (RiskResult *)resultForProjectID:(NSString *)projectID itemName:(NSString *)itemName subItemName:(NSString *)subItemName;

@end
