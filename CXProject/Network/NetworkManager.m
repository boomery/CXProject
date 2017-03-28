
//
//  NetworkManager.m
//  CXProject
//
//  Created by ZhangChaoxin on 16/5/5.
//  Copyright © 2016年 ZhangChaoxin. All rights reserved.
//

#import "NetworkManager.h"
#import "NetworkURLDefine.h"
@implementation NetworkManager

+ (NetworkManager *)shareManager
{
    static NetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NetworkManager alloc] initWithBaseURL:[NSURL URLWithString:API_HOST]];
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    return manager;
}

+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure showHud:(BOOL)showHud
{
    if (showHud)
    {
        [DialogHandler showDlg];
    }
    return [[NetworkManager shareManager] GET:URLString parameters:parameters success:success failure:failure];
}

+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure showHud:(BOOL)showHud
{
    if (showHud)
    {
        [DialogHandler showDlg];
    }
    return [[NetworkManager shareManager] POST:URLString parameters:parameters success:success failure:failure];
}

+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                     parameters:(id)parameters
      constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure showHud:(BOOL)showHud
{
    if (showHud)
    {
        [DialogHandler showDlg];
    }
    return [[NetworkManager shareManager] POST:URLString parameters:parameters constructingBodyWithBlock:block success:success failure:failure];
}
@end
