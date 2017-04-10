//
//  Data.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/10.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Data : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic, strong) NSArray *subItem;
@property (nonatomic, strong) Data *data;

@end
