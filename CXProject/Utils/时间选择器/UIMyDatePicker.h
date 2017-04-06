//
//  UIMyDatePicker.h
//  OpenAllTheWay
//
//  Created by Andy on 14-10-30.
//  Copyright (c) 2014年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIMyDatePicker;
@protocol UIMyDatePickerDelegate;

@interface UIMyDatePicker : UIView
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, weak) id <UIMyDatePickerDelegate>delegate;

- (instancetype) initWithDelegate:(id <UIMyDatePickerDelegate>)delegate;

@end

@protocol UIMyDatePickerDelegate <NSObject>
@optional
- (void)myDatePickerDidClickCancel:(UIMyDatePicker *)picker;
- (void)myDatePickerDidClickToday:(UIMyDatePicker *)picker;
@required
- (void)myDatePickerDidClickSure:(UIMyDatePicker *)picker;

@end
