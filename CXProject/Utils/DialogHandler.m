//
//  DataHander.m
//  CaCaXian
//
//  Created by Andy on 13-4-27.
//  Copyright (c) 2013年 Andy. All rights reserved.
//

#import "DialogHandler.h"
#define COLOR [UIColor colorWithRed:0.98 green:0.33 blue:0.03 alpha:1]
@implementation DialogHandler
static DialogHandler* dialogHandler = nil;
+(DialogHandler *)sharedDialogHandler
{
    @synchronized(self){
        if (dialogHandler == nil) {
            dialogHandler = [[self alloc] init];
            
        }
    }
    return dialogHandler;
}

+ (void)showDlg
{
    NSString *loadString = NSLocalizedString(@"loading", @"");
    [SVProgressHUD setBackgroundColor:COLOR];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
//    [SVProgressHUD setMaxSupportedWindowLevel:UIWindowLevelStatusBar];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:loadString];
}
+ (void)hideDlg
{
    [SVProgressHUD dismiss];
}

+ (void)showErrorWithTitle:(NSString *)title
{
    NSString *errorString = NSLocalizedString(title, @"");
    [SVProgressHUD setBackgroundColor:COLOR];
    [SVProgressHUD showErrorWithStatus:errorString maskType:SVProgressHUDMaskTypeNone];
}

+ (void)showSuccessWithTitle:(NSString *)title
{
    NSString *errorString = NSLocalizedString(title, @"");
//    [SVProgressHUD setBackgroundColor:COLOR];
    [SVProgressHUD showInfoWithStatus:title];
}
+ (void)showSuccessWithTitle:(NSString *)title completionBlock:(void(^)())completionBlock
{
    NSString *errorString = NSLocalizedString(title, @"");
    [SVProgressHUD setBackgroundColor:COLOR];
    [SVProgressHUD showSuccessWithStatus:errorString];
    [SVProgressHUD sharedView].dismissBlock = ^{
        if (completionBlock)
        {
            completionBlock();
        }
    };
}
+ (void)showInfoWithTitle:(NSString *)title
{
    NSString *errorString = NSLocalizedString(title, @"");
    [SVProgressHUD setBackgroundColor:COLOR];
    [SVProgressHUD showInfoWithStatus:errorString maskType:SVProgressHUDMaskTypeNone];
}

@end
