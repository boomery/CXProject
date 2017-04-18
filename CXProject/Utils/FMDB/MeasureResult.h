//
//  MeasureResult.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/17.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeasureResult : NSObject

@property (nonatomic, copy) NSString *projectID;
@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *subItemName;
@property (nonatomic, copy) NSString *measureArea;
@property (nonatomic, copy) NSString *measurePoint;
@property (nonatomic, copy) NSString *measureValues;
@property (nonatomic, copy) NSString *designValues;
@property (nonatomic, copy) NSString *measureResult;
@property (nonatomic, copy) NSString *mesaureIndex;

@end
