//
//  PhotoEditorViewController.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/1.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSDrawView.h"
@interface PhotoEditorViewController : BaseViewController

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) LSDrawView *drawView;
@property (nonatomic, copy) void (^imageBlock)(UIImage *image);

@end
