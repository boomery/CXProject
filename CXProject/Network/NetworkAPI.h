//
//  NetworkAPI.h
//  CXProject
//
//  Created by ZhangChaoxin on 16/5/5.
//  Copyright © 2016年 ZhangChaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkDefine.h"
#import "NetworkURLDefine.h"
#import "NetworkManager.h"

@class ListModel;
@class ThreadModel;
@interface NetworkAPI : NSObject

#pragma mark - 获取栏目列表
+ (void)getMainListSuccessBlock:(SuccessBlock)successBlock
                   failureBlock:(FailureBlock)failureBlock
                        showHUD:(BOOL)showHUD;

#pragma mark - 获取主题列表
+ (void)getListDetailgetListDetailWithModel:(ListModel *)model
                                       page:(int)page
                               SuccessBlock:(SuccessBlock)successBlock
                               failureBlock:(FailureBlock)failureBlock
                                    showHUD:(BOOL)showHUD;

#pragma mark - 获取主题详情
+ (void)getThreadDetailgetListDetailWithModel:(ThreadModel *)model
                                         page:(int)page
                                 SuccessBlock:(SuccessBlock)successBlock
                                 failureBlock:(FailureBlock)failureBlock
                                      showHUD:(BOOL)showHUD;

@end
