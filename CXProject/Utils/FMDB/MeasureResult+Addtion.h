//
//  MeasureResult+Addtion.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/17.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "MeasureResult.h"
@interface MeasureResult (Addtion)

+ (void)insertNewMeasureResult:(MeasureResult *)result;

+ (NSArray *)resultsForProjectID:(NSString *)projectID itemName:(NSString *)itemName subItemName:(NSString *)subItemName;
@end
