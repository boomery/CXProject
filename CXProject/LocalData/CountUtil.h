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
struct standard{
    float min;
    float max;
};

int count1(int value1,int value2, int design,struct standard s);
int count2(int value1, struct standard s);
int count3(int value1, int value2, int value3, int value4, int value5, int guidingValue, struct standard s);
#endif /* CountUtil_h */
