//
//  Project.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/1.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "Project.h"
//项目名称
#define KEY_NAME @"name"
//项目区域
#define KEY_DISTRICT @"district"
//项目标段
#define KEY_SITE @"site"
//评估伦次
#define KEY_TURN @"turn"
//监理单位
#define KEY_SUPERVISORY @"supervisory"
//评估日期
#define KEY_MEASURE_DATE @"measure_date"
//评估组长
#define KEY_CAPTAIN @"captain"
//评估组员
#define KEY_MEMBERS @"members"
//施工单位
#define KEY_BUILDER @"builder"
//项目地址
#define KEY_ADDRESS @"address"
//项目负责人
#define KEY_CHARGEMAN @"chargeman"
//项目面积
#define KEY_AREA @"area"
//项目进度
#define KEY_PROGRESS @"progress"
//交付日期
#define KEY_ENDDATE @"end_date"
@implementation Project

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.name = [aDecoder decodeObjectForKey:KEY_NAME];
    self.district = [aDecoder decodeObjectForKey:KEY_DISTRICT];
    self.site = [aDecoder decodeObjectForKey:KEY_SITE];
    self.turn = [aDecoder decodeObjectForKey:KEY_TURN];
    self.supervisory = [aDecoder decodeObjectForKey:KEY_SUPERVISORY];

    self.measure_date = [aDecoder decodeObjectForKey:KEY_MEASURE_DATE];
    self.captain = [aDecoder decodeObjectForKey:KEY_CAPTAIN];
    self.members = [aDecoder decodeObjectForKey:KEY_MEMBERS];
    self.builder = [aDecoder decodeObjectForKey:KEY_BUILDER];
    self.address = [aDecoder decodeObjectForKey:KEY_ADDRESS];
    
    self.chargeman = [aDecoder decodeObjectForKey:KEY_CHARGEMAN];
    self.area = [aDecoder decodeObjectForKey:KEY_AREA];
    self.progress = [aDecoder decodeObjectForKey:KEY_PROGRESS];
    self.end_date = [aDecoder decodeObjectForKey:KEY_ENDDATE];


    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:KEY_NAME];
    [aCoder encodeObject:self.district forKey:KEY_DISTRICT];
    [aCoder encodeObject:self.site forKey:KEY_SITE];
    [aCoder encodeObject:self.turn forKey:KEY_TURN];
    [aCoder encodeObject:self.supervisory forKey:KEY_SUPERVISORY];
    
    [aCoder encodeObject:self.measure_date forKey:KEY_MEASURE_DATE];
    [aCoder encodeObject:self.captain forKey:KEY_CAPTAIN];
    [aCoder encodeObject:self.members forKey:KEY_MEMBERS];
    [aCoder encodeObject:self.builder forKey:KEY_BUILDER];
    [aCoder encodeObject:self.address forKey:KEY_ADDRESS];
    
    [aCoder encodeObject:self.chargeman forKey:KEY_CHARGEMAN];
    [aCoder encodeObject:self.area forKey:KEY_AREA];
    [aCoder encodeObject:self.progress forKey:KEY_PROGRESS];
    [aCoder encodeObject:self.end_date forKey:KEY_ENDDATE];
}


@end
