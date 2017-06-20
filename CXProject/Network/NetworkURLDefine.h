//
//  NetworkURLDefine.h
//  CXProject
//
//  Created by ZhangChaoxin on 16/5/4.
//  Copyright © 2016年 ZhangChaoxin. All rights reserved.
//

#ifndef NetworkURLDefine_h
#define NetworkURLDefine_h

/**
 *  栏目详细接口前缀
 */

#define API_HOST @"http://10.3.2.156:8080"

// 接口路径全拼
#define PATH(_path) [NSString stringWithFormat:@"%@/%@", API_HOST, _path]



/**
 *  请在此定义请求URL
 */

#pragma mark - 用户登录

#define DEF_API_LOGIN @"PDManage/userAction/login"

#define DEF_API_UPLOAD @"PDManage/shiceAction/save"


#endif /* NetworkURLDefine_h */
