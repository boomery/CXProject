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
#pragma mark - 上传照片
+ (void)uploadImage:(UIImage *)image type:(NSString *)type projectID:(NSString *)projectID showHUD:(BOOL)showHUD successBlock:(SuccessBlock)successBlock
       failureBlock:(FailureBlock)failureBlock
{
    __block float progress = 0.0;
    if (showHUD)
    {
        [SVProgressHUD showProgress:progress];
    }
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);

    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    
    //间隔时间
    uint64_t interval = 0.2 * NSEC_PER_SEC;
    
    dispatch_source_set_timer(timer, start, interval, 0);
    
    //设置回调
    dispatch_source_set_event_handler(timer, ^{
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD showProgress:progress status:@"上传中..."];
        if(progress < 1.0f)
        {
            progress += 0.05f;
        }
        else
        {
            dispatch_cancel(timer);
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            successBlock(nil);
        }
    });
    //启动timer
    dispatch_resume(timer);
}

- (void)dismiss
{
    [SVProgressHUD showSuccessWithStatus:@"上传完成"];
}
#pragma mark - 获取栏目列表
+ (void)getMainListSuccessBlock:(SuccessBlock)successBlock
                   failureBlock:(FailureBlock)failureBlock
                        showHUD:(BOOL)showHUD
{
//    [NetworkManager GET:DEF_API_MAIN parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        if ([responseObject isKindOfClass:[NSDictionary class]])
//        {
//            BOOL state = responseObject[@"success"];
//            if (state == 1)
//            {
//                NSArray *forumArray = responseObject[@"forum"];
//                NSMutableArray *listArray = [[NSMutableArray alloc] init];
//                for (NSDictionary *dict in forumArray)
//                {
//                    ListModel *model = [[ListModel alloc] initWithDictionary:dict];
//                    model.tag = [forumArray indexOfObject:dict];
//                    [listArray addObject:model];
//                }
//                successBlock(listArray);
//            }
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        failureBlock(error);
//    } showHud:showHUD];
}

#pragma mark - 获取主题列表
+ (void)getListDetailgetListDetailWithModel:(ListModel *)model
                                       page:(int)page
                               SuccessBlock:(SuccessBlock)successBlock
                               failureBlock:(FailureBlock)failureBlock
                                    showHUD:(BOOL)showHUD
{
//    NSString *string = DEF_API_PATH(model.name,page);
//    [NetworkManager GET:[string encodedString:string] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        if ([responseObject isKindOfClass:[NSDictionary class]])
//        {
//            BOOL state = responseObject[@"success"];
//            if (state == 1)
//            {
//                NSDictionary *dataDict = responseObject[@"data"];
//                NSArray *threadsDictArray = dataDict[@"threads"];
//                NSMutableArray *threadsArray = [[NSMutableArray alloc] init];
//                for (NSDictionary *dict in threadsDictArray)
//                {
//                    ThreadModel *model = [[ThreadModel alloc] initWithDictionary:dict];
//                    [threadsArray addObject:model];
//                }
//                successBlock(threadsArray);
//            }
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        failureBlock(error);
//    } showHud:showHUD];
}

#pragma mark - 获取主题详情
+ (void)getThreadDetailgetListDetailWithModel:(ThreadModel *)model
                                       page:(int)page
                               SuccessBlock:(SuccessBlock)successBlock
                               failureBlock:(FailureBlock)failureBlock
                                    showHUD:(BOOL)showHUD
{
//    NSString *string = DEF_API_THREAD([model.theID integerValue],page);
//    [NetworkManager GET:[string encodedString:string] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        if ([responseObject isKindOfClass:[NSDictionary class]])
//        {
//            BOOL state = responseObject[@"success"];
//            if (state == 1)
//            {
//                NSArray *replysArray = responseObject[@"replys"];
//                NSMutableArray *finalArray = [[NSMutableArray alloc] init];
//                for (NSDictionary *dict in replysArray)
//                {
//                    ThreadModel *model = [[ThreadModel alloc] initWithDictionary:dict];
//                    [finalArray addObject:model];
//                }
//                successBlock(finalArray);
//            }
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        failureBlock(error);
//    } showHud:showHUD];
}
@end
