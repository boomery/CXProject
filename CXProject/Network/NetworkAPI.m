//
//  NetworkAPI.m
//  CXProject
//
//  Created by ZhangChaoxin on 16/5/5.
//  Copyright © 2016年 ZhangChaoxin. All rights reserved.
//

#import "NetworkAPI.h"
@implementation NetworkAPI

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
       failureBlock:(FailureBlock)failureBlock
{
//    UIImage *resizeImage = [image resizedImageToSize:CGSizeMake(150, 150)];
    NSData *data = UIImagePNGRepresentation(image);
    NSString *string = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

    NSDictionary *json = @{@"data" : string,
                           @"projectID" : projectID,
                           @"name" : name,
                           @"savetime" : savetime,
                           @"place" : place,
                           @"kind" : kind,
                           @"item" : item,
                           @"subitem" : subitem,
                           @"subitem2" : subitem2,
                           @"subitem3" : subitem3,
                           @"responsibility" : responsibility,
                           @"repairtime" : repairtime};

    NSData *dataBody = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    
    [NetworkManager POST:DEF_API_UPLOAD parameters:nil body:dataBody success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD showInfoWithStatus:@"成功"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showInfoWithStatus:error.localizedDescription];
    } showHud:YES];
}

- (void)dismiss
{
    [SVProgressHUD showSuccessWithStatus:@"上传完成"];
}
@end
