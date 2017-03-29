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
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) TabBarController *tab;
@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

