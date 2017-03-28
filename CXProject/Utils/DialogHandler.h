//
//  DataHander.h
//  CaCaXian
//
//  Created by Andy on 13-4-27.
//  Copyright (c) 2013年 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVProgressHUD.h"
@interface DialogHandler : NSObject

+ (DialogHandler *)sharedDialogHandler;

+ (void)showDlg;
+ (void)hideDlg;

+ (void)showSuccessWithTitle:(NSString *)title;
+ (void)showSuccessWithTitle:(NSString *)title completionBlock:(void(^)())completionBlock;
+ (void)showErrorWithTitle:(NSString *)title;
+ (void)showInfoWithTitle:(NSString *)title;

//取消请求
//-(void)cancelRequest;
@end
