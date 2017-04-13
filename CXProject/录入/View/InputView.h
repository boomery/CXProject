//
//  InputView.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/13.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputView : UIView
- (void)setUpViewsWithMeasureGroup:(NSInteger)group//几组测量值
                      MeasurePoint:(NSInteger)measurePoint//每一组测量值有几个点
                        haveDesign:(BOOL)haveDesign//是否有设计值
                        designName:(NSArray *)designName;//测量值名称数组，元素个数与测量值组数相同
@end
