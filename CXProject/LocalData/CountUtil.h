//
//  CountUtil.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/19.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#ifndef CountUtil_h
#define CountUtil_h

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
struct standard{
    float min;
    float max;
};

int count1(float value1,float value2, float design,struct standard s);
int count2(float value1, struct standard s);
int count3(float value1, float value2, float value3, float value4, float value5, struct standard s);
#endif /* CountUtil_h */
