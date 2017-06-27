//
//  SelectionView.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/20.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SelectionViewDelegate;

@interface SelectionView : UIView

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, weak) id <SelectionViewDelegate>delegate;

+ (void)showInView:(UIView *)view leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle delegate:(id <SelectionViewDelegate>)delegate;
+ (void)dismiss;
@end

@protocol SelectionViewDelegate <NSObject>

- (void)didClickSelectAll;
- (void)didClickUpload;

@end
