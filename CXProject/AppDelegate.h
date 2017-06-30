//
//  AppDelegate.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/3/22.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TabBarController.h"

static NSString *appKey = @"a53a1af63a367a61b0c93b1a";
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) TabBarController *tab;
@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

