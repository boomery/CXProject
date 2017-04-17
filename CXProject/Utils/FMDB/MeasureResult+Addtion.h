//
//  MeasureResult+Addtion.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/17.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "MeasureResult.h"
@interface MeasureResult (Addtion)
/*
 projectID;
 itemName;
 subItemName;
 measureArea;
 measurePoint;
 MeasureValues;
 designValues;
 measureResult;
 index;
 */
+ (void)insertMeasureResultWithProjectID:(NSString *)projectID
                                itemName:(NSString *)itemName
                             subItemName:(NSString *)subItemName
                             measureArea:(NSString *)measureArea
                            measurePoint:(NSString *)measurePoint
                           MeasureValues:(NSString *)MeasureValues
                            designValues:(NSString *)designValues
                           measureResult:(NSString *)measureResult
                            mesaureIndex:(NSString *)mesaureIndex;


@end
