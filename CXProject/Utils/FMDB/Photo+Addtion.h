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

+ (BOOL)deletePhoto:(Photo *)photo;

+ (NSMutableArray *)unsortedPhotosForProjectID:(NSString *)projectID kind:(NSString *)kind;

+ (void)countPhotoForProjectID:(NSString *)projectID kind:(NSString *)kind item:(NSString *)item completionBlock:(void(^)(NSString *index))block;

+ (void)photosForProjectID:(NSString *)projectID kind:(NSString *)kind item:(NSString *)item completionBlock:(void(^)(NSMutableArray *resultArray))block;

+ (void)photosForProjectID:(NSString *)projectID item:(NSString *)item subItem:(NSString *)subItem completionBlock:(void(^)(NSMutableArray *resultArray))block;

+ (NSString *)textKindForIndex:(NSInteger)index;

+ (void)saveManagementScore:(NSString *)score projectID:(NSString *)projectID event:(Event *)event subEvent:(Event *)subEvent;
+ (NSString *)managementScoreForProjectID:(NSString *)projectID event:(Event *)event subEvent:(Event *)subEvent;
@end
