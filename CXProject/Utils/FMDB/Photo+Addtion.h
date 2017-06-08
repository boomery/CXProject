//
//  Photo+Addtion.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/5.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "Photo.h"

@interface Photo (Addtion)

+ (void)insertNewPhoto:(Photo *)photo;
+ (NSMutableArray *)unsortedPhotosForProjectID:(NSString *)projectID kind:(NSString *)kind;

+ (NSString *)textKindForIndex:(NSInteger)index;
@end
