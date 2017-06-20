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
               type:(NSString *)type
          projectID:(NSString *)projectID
            showHUD:(BOOL)showHUD
       successBlock:(SuccessBlock)successBlock
       failureBlock:(FailureBlock)failureBlock;
@end
