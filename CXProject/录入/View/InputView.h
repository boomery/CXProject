//
//  InputView.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/13.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^Block)();
@interface InputView : UIView
@property (nonatomic, weak) id delegate;
@property (nonatomic, copy) Block saveBlock;
@property (nonatomic, copy) Block showBlock;
@property (nonatomic, copy) Block deleteBlock;

- (void)setUpViewsWithMeasurePoint:(NSInteger)measurePoint//每一组测量值有几个点
                        haveDesign:(BOOL)haveDesign//是否有设计值
                        designName:(NSArray *)designName;//测量值名称数组，元素个数与测量值组数相同

- (void)beinEditing;

- (BOOL)haveSetValue;

- (void)setMeasureValues:(NSString *)measureValues;
- (void)setDesignValues:(NSString *)designValues;
//多个值用分号隔开
- (NSString *)measureValues;
- (NSString *)designValues;
@end

@protocol InputViewDelegate <NSObject>

- (void)lastTextFieldWillReturn;

@end
