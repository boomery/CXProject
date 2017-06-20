//
//  NetworkAPI.m
//  CXProject
//
//  Created by ZhangChaoxin on 16/5/5.
//  Copyright © 2016年 ZhangChaoxin. All rights reserved.
//

#import "NetworkAPI.h"
@implementation NetworkAPI

static dispatch_source_t timer;

#pragma mark - 用户登录
+ (void)loginWithUserName:(NSString *)name
                 password:(NSString *)password
                  showHUD:(BOOL)showHUD
             successBlock:(SuccessBlock)successBlock
             failureBlock:(FailureBlock)failureBlock
{
    NSDictionary *json = @{@"empNo" : name, @"password" : password};
    NSData *body = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    
    [NetworkManager POST:DEF_API_LOGIN parameters:nil body:body success:^(NSURLSessionDataTask *task, id responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureBlock(error);
    } showHud:showHUD];
}

#pragma mark - 上传照片
+ (void)uploadImage:(UIImage *)image type:(NSString *)type projectID:(NSString *)projectID showHUD:(BOOL)showHUD successBlock:(SuccessBlock)successBlock
       failureBlock:(FailureBlock)failureBlock
{
    [NetworkManager POST:DEF_API_UPLOAD parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:[NSData data] name:@"image"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } showHud:YES];
    
//    __block float progress = 0.0;
//    if (showHUD)
//    {
//        [SVProgressHUD showProgress:progress];
//    }
//    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
//
//    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    //开始时间
//    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
//    
//    //间隔时间
//    uint64_t interval = 0.2 * NSEC_PER_SEC;
//    
//    dispatch_source_set_timer(timer, start, interval, 0);
//    
//    //设置回调
//    dispatch_source_set_event_handler(timer, ^{
//        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
//        [SVProgressHUD showProgress:progress status:@"上传中..."];
//        if(progress < 1.0f)
//        {
//            progress += 0.05f;
//        }
//        else
//        {
//            dispatch_cancel(timer);
//            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
//            successBlock(nil);
//        }
//    });
//    //启动timer
//    dispatch_resume(timer);
}

- (void)dismiss
{
    [SVProgressHUD showSuccessWithStatus:@"上传完成"];
}
@end
