//
//  Risk_Progress_PhotoEditorViewController.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/5.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "BaseViewController.h"
#import "LSDrawView.h"
@interface Risk_Progress_PhotoEditorViewController : BaseViewController

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) void (^imageBlock)(UIImage *image, NSInteger kind);
@property (nonatomic, assign) BOOL haveTag;

@end
