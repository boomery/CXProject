//
//  MHKeyboard.m
//  MHProject
//
//  Created by Andy on 15/5/12.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "MHKeyboard.h"
#import "MHKeyboard+Animation.h"
#import "MHKeyboard+AccessObject.h"
#import "UIView+MHKeyboardFirstResponderNotify.h"


@interface MHKeyboard ()

+ (void)keyboardWillShow:(NSNotification *)notification;
+ (void)keyboardWillHide:(NSNotification *)notification;
+ (void)addObservers;
+ (void)removeObservers;

@end

@implementation MHKeyboard

#pragma mark - class method
+ (void)addRegisterTheViewNeedMHKeyboard:(UIView *)view
{
    [self objects].observerView         = view;
    [self objects].originalViewFrame    = view.frame;
    [self objects].isKeyboardShow       = NO;
    [self addObservers];
}

+ (void)removeRegisterTheViewNeedMHKeyboard
{
    objc_removeAssociatedObjects(self);
    [self removeObservers];
}


#pragma mark - private
+ (void)keyboardWillShow:(NSNotification *)notification
{
    // 第一次看到键盘
    if (![self objects].isKeyboardShow)
    {
        [self objects].isKeyboardShow               = YES;
        [self objects].keyboardAnimationDutation    = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [self objects].keyboardFrame                = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        // get UITextEffectsWindow
        for (UIWindow *eachWindow in [UIApplication sharedApplication].windows)
        {
            if ([eachWindow isKindOfClass:NSClassFromString(@"UITextEffectsWindow")])
            {
                [self objects].textEffectsWindow = eachWindow;
            }
        }
        [self mhKeyboardAnimation];
    }
    else
    {
        // 当键盘大小有变动时，还会再进来一次
        [self objects].keyboardAnimationDutation    = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [self objects].keyboardFrame                = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        [self mhKeyboardAnimation];
    }
}

+ (void)keyboardWillHide:(NSNotification *)notification
{
    [self objects].isKeyboardShow = NO;
    [self mhKeyboardAnimation];
}

+ (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

+ (void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
