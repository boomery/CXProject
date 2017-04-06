//
//  MHKeyboard.h
//  MHProject
//
//  Created by Andy on 15/5/12.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHKeyboard : NSObject


#pragma mark - 添加键盘通知
/**
 *  在viewController起始位置的地方添加该方法即可
 *
 *  @param view 这里的view，是需要上移的view
 */
+ (void)addRegisterTheViewNeedMHKeyboard:(UIView *)view;


#pragma mark - 移除键盘通知
/**
 *  在结束的地方添加该方法即可
 */
+ (void)removeRegisterTheViewNeedMHKeyboard;

@end
