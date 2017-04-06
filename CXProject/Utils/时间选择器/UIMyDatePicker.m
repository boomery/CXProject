//
//  UIMyDatePicker.m
//  OpenAllTheWay
//
//  Created by Andy on 14-10-30.
//  Copyright (c) 2014年 Andy. All rights reserved.
//

#import "UIMyDatePicker.h"
//#import "UIView+Genie.h"

@implementation UIMyDatePicker

- (instancetype)initWithDelegate:(id<UIMyDatePickerDelegate>)delegate
{
    if (self = [super init])
    {
        _delegate = delegate;
        
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _datePicker.locale = locale;
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.frame = CGRectMake(0, 44, DEF_SCREEN_WIDTH, 216);
        [self addSubview:_datePicker];
        
        UIToolbar *tool = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 44)];
        tool.userInteractionEnabled = YES;
        tool.translucent = NO;
//        tool.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Left_ditu"]];
        [self addSubview:tool];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancel.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [cancel setTitleColor:[UIColor colorWithRed:0.37 green:0.73 blue:0.47 alpha:1] forState:UIControlStateNormal];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel setTitleColor:DEF_RGB_COLOR(61, 189, 244) forState:UIControlStateNormal];
        cancel.layer.cornerRadius = 3.f;
        [cancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        cancel.frame = CGRectMake(20, 12, 40, 17);
        [tool addSubview:cancel];
        
        UIButton *today = [UIButton buttonWithType:UIButtonTypeCustom];
        [today setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        today.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [today setTitleColor:[UIColor colorWithRed:0.37 green:0.73 blue:0.47 alpha:1] forState:UIControlStateNormal];
        [today setTitle:@"今天" forState:UIControlStateNormal];
        [today setTitleColor:DEF_RGB_COLOR(61, 189, 244) forState:UIControlStateNormal];
        today.frame = CGRectMake(DEF_SCREEN_WIDTH - 120 , 12, 40, 17);
        today.layer.cornerRadius = 3.f;
        [today addTarget:self action:@selector(today) forControlEvents:UIControlEventTouchUpInside];
        [tool addSubview:today];
        
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sureButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [sureButton setTitleColor:[UIColor colorWithRed:0.37 green:0.73 blue:0.47 alpha:1] forState:UIControlStateNormal];
        [sureButton setTitle:@"完成" forState:UIControlStateNormal];
        [sureButton setTitleColor:DEF_RGB_COLOR(61, 189, 244) forState:UIControlStateNormal];
        sureButton.frame = CGRectMake(DEF_SCREEN_WIDTH - 60 , 12, 40, 17);
        sureButton.layer.cornerRadius = 3.f;
        [sureButton addTarget:self action:@selector(secureButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [tool addSubview:sureButton];
    }
    return self;
}

- (void)cancel
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(myDatePickerDidClickCancel:)])
    {
        [self.delegate myDatePickerDidClickCancel:self];
    }
}

- (void)today
{
    [self.datePicker setDate:[NSDate date] animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(myDatePickerDidClickToday:)])
    {
        [self.delegate myDatePickerDidClickToday:self];
    }
}

- (void)secureButtonClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(myDatePickerDidClickSure:)])
    {
        [self.delegate myDatePickerDidClickSure:self];
    }
}

@end
