//
//  Risk_Progress_ItemViewController.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/7.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "BaseViewController.h"

@interface Risk_Progress_ItemViewController : UITableViewController

@property (nonatomic, strong) Event *event;

@property (nonatomic, copy) void (^saveBlock)(NSArray *itemArray);

@property (nonatomic, strong) NSMutableArray *itemArray;

@end
