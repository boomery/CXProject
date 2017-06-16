//
//  SimpleItemTableViewController.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/14.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleItemTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, copy) void (^saveBlock)(NSString *string);

@end
