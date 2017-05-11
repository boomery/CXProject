//
//  Data.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/10.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "Data.h"
@implementation Data

+ (Data *)dataWithDict:(NSDictionary *)dict
{
    NSMutableArray *eventArray = [[NSMutableArray alloc] init];

    Data *data = [[Data alloc] init];
    data.key = @"events";
    
    NSArray *eventsArray = dict[data.key];
    for (NSDictionary *dict in eventsArray)
    {
        Event *event = [[Event alloc] init];
        event.name = dict[@"name"];
        NSArray *dictArray = dict[@"subEvents"];
        for (NSDictionary *subDict in dictArray)
        {
            Event *subEvent = [[Event alloc] init];
            subEvent.name = subDict[@"name"];
            subEvent.needDesgin = [subDict[@"needDesign"] boolValue];
            subEvent.designName = subDict[@"designName"];
            subEvent.measurePoint = [subDict[@"measurePoint"] integerValue];
            subEvent.min = [subDict[@"min"] floatValue];
            subEvent.max = [subDict[@"max"] floatValue];
            subEvent.condition = subDict[@"condition"];
            subEvent.max2 = [subDict[@"max2"] floatValue];
            subEvent.textStandard = subDict[@"textStandard"];
            subEvent.limit = subDict[@"limit"];
            subEvent.method = subDict[@"method"];
            [event.events addObject:subEvent];
        }
        [eventArray addObject:event];
        data.events = eventArray;
    }
    return data;
}

@end
