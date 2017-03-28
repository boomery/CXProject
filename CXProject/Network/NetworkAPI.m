//
//  NetworkAPI.m
//  CXProject
//
//  Created by ZhangChaoxin on 16/5/5.
//  Copyright © 2016年 ZhangChaoxin. All rights reserved.
//

#import "NetworkAPI.h"
@implementation NetworkAPI

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
