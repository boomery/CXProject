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
int count1(float value1,float value2, float design,struct standard s)
{
    float a = fabsf(value1 - design);
    float b = fabsf(value2 - design);
    float largerDiffrence = a > b ? (value1 - design) : (value2 - design);
    if (largerDiffrence < s.min || largerDiffrence > s.max)
    {
        return 1;
    }
    else
        return 0;
}

/* 算法中0表示合格 1表示不合格 */
//算法2:每个录入点直接与标准值比较，计算一个合格点;
int count2(float value1, struct standard s)
{
    if (value1 < s.min || value1 > s.max)
    {
        return 1;
    }
    else
        return 0;
}

/* 算法中0表示合格 1表示不合格 */
//算法3:每五个录入点数，以最小值为基准，其余点数差值与标准值比较相差在规定值内的，不合格点有一个算一个。如果有任意一个差值在规定值外的这五个值都算不合格点，并且五个点均按最大偏差值计
struct results count3(float value1, float value2, float value3, float value4, float value5, float limit,struct standard s)
{
    struct results res;
    res.result1 = 0;
    res.result2 = 0;
    res.result3 = 0;
    res.result4 = 0;
    res.result5 = 0;
    
    float a[5] = {value1, value2, value3, value4, value5};
    float min = a[0];
    for (int i = 0; i<4; i++)
    {
        min = min < a[i+1]? min:a[i+1];
    }
    for (int i = 0; i<5; i++)
    {
        float diffrence = a[i] - min;
        if(diffrence > limit)
        {
            res.result1 = 1;
            res.result2 = 1;
            res.result3 = 1;
            res.result4 = 1;
            res.result5 = 1;
            return res;
        }
        else
        {
            switch (i)
            {
                case 0:
                {
                    res.result1 = diffrence <= s.max ? 0 : 1;
                }
                    break;
                case 1:
                {
                    res.result2 = diffrence <= s.max ? 0 : 1;
                }
                    break;
                case 2:
                {
                    res.result3 = diffrence <= s.max ? 0 : 1;
                }
                    break;
                case 3:
                {
                    res.result4 = diffrence <= s.max ? 0 : 1;
                }
                    break;
                case 4:
                {
                    res.result5 = diffrence <= s.max ? 0 : 1;
                }
                    break;
                default:
                    break;
            }
        }
    }
    return res;
}

/* 算法中0表示合格 1表示不合格 */
//算法4:每个录入点与设计值之差直接与标准值比较,计算一个合格点
int count4(float value1, float design,struct standard s)
{
    float diffrence = value1 - design;
    if (diffrence < s.min || diffrence > s.max)
    {
        return 1;
    }
    else
        return 0;
}






















