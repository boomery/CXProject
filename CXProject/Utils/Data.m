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
        NSArray *keyArray = [dict allKeys];
        if (keyArray.count > 0)
        {
            event.name = keyArray[0];
        }
        NSArray *dictArray = dict[event.name];
        for (NSDictionary *subDict in dictArray)
        {
            Event *subEvent = [[Event alloc] init];
            NSArray *keyArray = [subDict allKeys];
            if (keyArray.count > 0)
            {
                subEvent.name = keyArray[0];
            }
            id obj = subDict[subEvent.name];
            if ([obj isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dicObj = (NSDictionary *)obj;
                subEvent.needDesgin = [dicObj[@"needDesign"] boolValue];
                subEvent.measurePoint = [dicObj[@"measurePoint"] integerValue];
                subEvent.min = [dicObj[@"min"] integerValue];
                subEvent.max = [dicObj[@"max"] integerValue];
                subEvent.explain = dicObj[@"explain"];
                subEvent.condition = dicObj[@"condition"];
                [event.events addObject:subEvent];
            }
           else if ([obj isKindOfClass:[NSArray class]])
           {
               for (NSDictionary *d in obj)
               {
                   
               }
           }
        }
       
        
        [eventArray addObject:event];
        data.events = eventArray;
    }
    return data;
}

@end
