//
//  CXDataBaseUtil.h
//  ACIM
//
//  Created by zcx on 15/1/27.
//  Copyright (c) 2015年 ownerblood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

#define MEASURE_TABLE @"MEASURE_TABLE"
@interface CXDataBaseUtil : NSObject

+ (FMDatabase *)database;

+(void)creatTable;

+ (NSString *)getDatabasePath;

@end
