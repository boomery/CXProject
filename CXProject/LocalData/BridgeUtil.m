//
//  BridgeUtil.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/19.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "BridgeUtil.h"
#import "CountUtil.h"
@implementation BridgeUtil

+ (NSString *)resultForMeasureValues:(NSString *)values designValues:(NSString *)designValues event:(Event *)event
{
    NSArray *measureArray = [values componentsSeparatedByString:@";"];
    NSArray *designArray = [designValues componentsSeparatedByString:@";"];
    struct standard s;
    s.min = event.min;
    s.max = event.max;
    int result;
    switch ([event.method integerValue])
    {
        case 1:
        {
            result = count1([measureArray[0] floatValue], [measureArray[1] floatValue], [designArray[0] floatValue], s);
        }
            break;
        case 2:
        {
           
            result = count2([measureArray[0] floatValue], s);
        }
            break;
        case 3:
        {
            result = count3([measureArray[0] floatValue], [measureArray[1] floatValue], [measureArray[2] floatValue], [measureArray[3] floatValue], [measureArray[4] floatValue], s);
        }
            break;
        case 4:
        {
            result = count4([measureArray[0] floatValue], [designArray[0] floatValue], s);
        }
            break;
        default:
            result = 1;
            break;
    }
    return [NSString stringWithFormat:@"%d",result];
}

@end
