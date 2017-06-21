//
//  FileManager.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/13.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Photo;
@interface FileManager : NSFileManager

+ (NSString *)currentTime;

+ (NSString *)imageName;

+ (BOOL)deleteImageForPhotoFilePath:(NSString *)filePath;

+ (BOOL)savePhoto:(Photo *)photo;

+ (NSString *)imagePathForPhoto:(Photo *)photo;
@end
