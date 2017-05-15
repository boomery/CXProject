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

struct results{
    int result1;
    int result2;
    int result3;
    int result4;
    int result5;
};

int count1(float value1,float value2, float design,struct standard s);

int count2(float value1, struct standard s);

struct results count3(float value1, float value2, float value3, float value4, float value5, float limit,struct standard s);

int count4(float value1, float design,struct standard s);

int count5(float value1);

int count6(float a[], int arrayNum, struct standard s);

int count7(float a[], int arrayNum, struct standard s);

struct results count8(float value1, float value2, float value3, float value4, float value5, float design,float limit,struct standard s);

int count9(float a[], int arrayNum, struct standard s);

int count10(float value1, float value2, struct standard s);

/*
 参数说明：
 value测量值
 limit 爆板判断点
 design 设计值
 results 结果结构体
 standard.min 标准最小值
 standard.max 标准最大值
 */

#endif /* CountUtil_h */
