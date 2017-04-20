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
    if (largerDiffrence > s.min && largerDiffrence < s.max)
    {
        return 0;
    }
    else
        return 1;
}
