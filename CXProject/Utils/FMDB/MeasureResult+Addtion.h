//
//  MeasureResult+Addtion.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/17.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "MeasureResult.h"
@interface MeasureResult (Addtion)

+ (void)deleteMeasureResult:(MeasureResult *)result;

+ (void)insertNewMeasureResult:(MeasureResult *)result;

+ (NSMutableDictionary *)resultsForProjectID:(NSString *)projectID itemName:(NSString *)itemName subItemName:(NSString *)subItemName;

+ (NSMutableDictionary *)resultsForProjectID:(NSString *)projectID itemName:(NSString *)itemName;

+ (BOOL)updateMeasureAreaMeasurePointDesignValuesWithMeasureResult:(MeasureResult *)result;

//+ (BOOL)updateMeasurePhotoName:(NSString *)photoName forMeasureResult:(MeasureResult *)result;

//userDefaults已经录入的点数个数存储在本地
//大项
+ (NSInteger)tNumOfResultsForProjectID:(NSString *)projectID itemName:(NSString *)itemName;
+ (NSInteger)tNumOfDesignResultsForProjectID:(NSString *)projectID itemName:(NSString *)itemName;
+ (NSInteger)tNumOfQualifiedForProjectID:(NSString *)projectID itemName:(NSString *)itemName;
+ (NSString *)tUploadTimeForProjectID:(NSString *)projectID itemName:(NSString *)itemName;

//分项
+ (NSInteger)numOfResultsForProjectID:(NSString *)projectID itemName:(NSString *)itemName subItemName:(NSString *)subItemName;
+ (NSInteger)numOfDesignResultsForProjectID:(NSString *)projectID itemName:(NSString *)itemName subItemName:(NSString *)subItemName;
+ (NSInteger)numOfQualifiedForProjectID:(NSString *)projectID itemName:(NSString *)itemName subItemName:(NSString *)subItemName;
@end
