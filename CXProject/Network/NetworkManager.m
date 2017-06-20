
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
//忽略过期方法警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
+ (NetworkManager *)shareManager
{
    static NetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NetworkManager alloc] initWithBaseURL:[NSURL URLWithString:API_HOST]];
//        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];//申明请求的数据是json类型
        manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
        manager.requestSerializer.timeoutInterval = API_TIME_OUT;
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", nil];

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
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD show];
    }
    return [[NetworkManager shareManager] GET:URLString parameters:parameters success:success failure:failure];
}

+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                          body:(NSData *)body
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure showHud:(BOOL)showHud
{
    if (showHud)
    {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD show];
    }
    NetworkManager *manager = [NetworkManager shareManager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.body = body;

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
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD show];
    }
    return [[NetworkManager shareManager] POST:URLString parameters:parameters constructingBodyWithBlock:block success:success failure:failure];
}
@end
