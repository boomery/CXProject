//
//  CountUtil.c
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/19.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#include "CountUtil.h"
/* 算法中0表示合格 1表示不合格 */
//算法1:每两个录入点数与设计值相差大的的差值与标准值比较，计算一个合格点;
int count1(int value1,int value2, int design,struct standard s)
{
    printf("%d,%d,%d,%f,%f",value1, value2, design , s.min, s.max);
    int a = abs(value1 - design);
    int b = abs(value2 - design);
    int largerDiffrence = a > b ? a : b;
    if (largerDiffrence >= s.min && largerDiffrence <= s.max)
    {
        return 0;
    }
    else
        return 1;
}

/* 算法中0表示合格 1表示不合格 */
//算法2:每个录入点直接与标准值比较，计算一个合格点;
int count2(int value1, struct standard s)
{
    if (value1 >= s.min && value1 <= s.max)
    {
        return 0;
    }
    else
        return 1;
}
/* 算法中0表示合格 1表示不合格 */
//算法3:每五个录入点数，以最小值为基准，其余点数差值与标准值比较相差在规定值内的，不合格点有一个算一个。如果有任意一个差值在规定值外的这五个值都算不合格点，并且五个点均按最大偏差值计
int count3(int value1, int value2, int value3, int value4, int value5, int design, struct standard s)
{
    if (value1 >= s.min && value1 <= s.max)
    {
        return 0;
    }
    else
        return 1;
}
