//
//  NetworkDefine.h
//  CXProject
//
//  Created by ZhangChaoxin on 16/5/4.
//  Copyright © 2016年 ZhangChaoxin. All rights reserved.
//

#ifndef NetworkDefine_h
#define NetworkDefine_h

/*请求类型*/
typedef enum {
    NetworkType_GET,
    NetworkType_POST
}NetworkType;

/**
 *  网络请求超时的时间
 */
#define API_TIME_OUT 60

/**
 *  socket连接超时的时间
 */
#define SOCKET_TIME_OUT 60
/**
 *  网络请求重新尝试的次数
 */
#define NetWorkRetryTimes     2

#if NS_BLOCKS_AVAILABLE

/**
 *  请求开始的回调（下载时用到）
 */
typedef void (^StartBlock)(void);

/**
 *  请求成功回调
 *
 *  @param returnData 回调block
 */
typedef void (^SuccessBlock)(id returnData);

/**
 *  请求失败回调
 *
 *  @param error 回调block
 */
typedef void (^FailureBlock)(NSError *error);
#endif

#endif /* NetworkDefine_h */
