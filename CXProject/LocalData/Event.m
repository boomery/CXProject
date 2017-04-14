//
//  Event.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/11.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "Event.h"

@implementation Event
- (id)init
{
    if (self = [super init])
    {
        _events = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
