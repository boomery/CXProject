//
//  Data.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/10.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "Data.h"
@implementation Data

+ (Data *)measureDataWithDict:(NSDictionary *)dict
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

+ (Data *)riskDataWithDict:(NSDictionary *)dict
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
            
            NSArray *dictArray2 = subDict[@"subEvents"];
            for (NSDictionary *subDict2 in dictArray2)
            {
                Event *subEvent2 = [[Event alloc] init];
                subEvent2.name = subDict2[@"name"];
                subEvent2.needDesgin = [subDict2[@"needDesign"] boolValue];
                subEvent2.designName = subDict2[@"designName"];
                subEvent2.measurePoint = [subDict2[@"measurePoint"] integerValue];
                subEvent2.min = [subDict2[@"min"] floatValue];
                subEvent2.max = [subDict2[@"max"] floatValue];
                subEvent2.condition = subDict2[@"condition"];
                subEvent2.max2 = [subDict2[@"max2"] floatValue];
                subEvent2.textStandard = subDict2[@"textStandard"];
                subEvent2.limit = subDict2[@"limit"];
                subEvent2.method = subDict2[@"method"];
                [subEvent.events addObject:subEvent2];
                
            }
        }
        [eventArray addObject:event];
        data.events = eventArray;
    }
    return data;
}

@end
