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

//用户登录
+ (void)loginWithUserName:(NSString *)name
                 password:(NSString *)password
                  showHUD:(BOOL)showHUD
             successBlock:(SuccessBlock)successBlock
             failureBlock:(FailureBlock)failureBlock;

//上传图片
+ (void)uploadImage:(UIImage *)image
          projectID:(NSString *)projectID
               name:(NSString *)name
           savetime:(NSString *)savetime
              place:(NSString *)place
               kind:(NSString *)kind
               item:(NSString *)item
            subitem:(NSString *)subitem
           subitem2:(NSString *)subitem2
           subitem3:(NSString *)subitem3
     responsibility:(NSString *)responsibility
         repairtime:(NSString *)repairtime
            showHUD:(BOOL)showHUD
       successBlock:(SuccessBlock)successBlock
       failureBlock:(FailureBlock)failureBlock;

+ (void)downloadProjectItemWithProjectID:(NSString *)projectID
                                 showHUD:(BOOL)showHUD
                            successBlock:(SuccessBlock)successBlock
                            failureBlock:(FailureBlock)failureBlock;

@end
