//
//  Photo.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/5.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "Photo.h"

@implementation Photo

- (id)init
{
    if (self = [super init])
    {
        _hasUpload = @"NO";
        _uploadTime = @"";
    }
    return self;
}

@end
