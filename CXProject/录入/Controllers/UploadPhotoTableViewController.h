//
//  UploadPhotoTableViewController.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/20.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "BaseViewController.h"

@interface UploadPhotoTableViewController : BaseViewController

@property (nonatomic, assign) BOOL isMultiSelect;
@property (nonatomic, assign) BOOL hasUpload;
@property (nonatomic, copy) void(^selectBlock)(BOOL select);

@property (nonatomic, copy) void(^uploadBlock)();
@end
