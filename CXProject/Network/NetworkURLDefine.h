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

#define API_HOST @"http://h.koukuko.com/api"

#define DEF_API_PATH(name,page) [NSString stringWithFormat:@"%@?page=%ld",name,page]

#define DEF_API_THREAD(name,page) [NSString stringWithFormat:@"t/%ld?page=%ld",name,page]


/**
 *  获取栏目与图片前缀
 */

#define DEF_API_FILE @"http://static.koukuko.com/h"


#define PATH(_path) [NSString stringWithFormat:@"%@/%@", DEF_API_FILE,_path]

//接口路径拼接
#define DEF_API_MAIN PATH(@"/cnn1.json")

#endif /* NetworkURLDefine_h */
