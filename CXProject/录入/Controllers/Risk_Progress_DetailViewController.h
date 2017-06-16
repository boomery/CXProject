//
//  Risk_Progress_DetailViewController.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/7.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "BaseViewController.h"
#import "Photo.h"
@interface Risk_Progress_DetailViewController : BaseViewController

@property (nonatomic, strong) NSArray *photoArray;

@property (nonatomic, strong) Photo *photo;
@property (nonatomic, copy) void(^saveBlock)(Photo *photo);

@end

