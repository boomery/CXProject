
//
//  FileManager.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/13.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "FileManager.h"
#import "CXDataBaseUtil.h"
#import "Photo.h"
@implementation FileManager
+ (NSString *)currentTime
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH点mm分ss秒"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

+ (NSString *)imageName
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH点mm分ss秒"];
    NSString *dateString = [formatter stringFromDate:date];
    NSString *imageName = [NSString stringWithFormat:@"image_create_at_%@.png",dateString];
    return imageName;
}

+ (BOOL)deleteImageForPhotoFilePath:(NSString *)filePath
{
    NSError *error;
    return [[self defaultManager] removeItemAtPath:filePath error:&error];
}

+ (BOOL)savePhoto:(Photo *)photo
{
    return [UIImageJPEGRepresentation(photo.image, 0.5) writeToFile:[FileManager imagePathForPhoto:photo] atomically:YES];
}

+ (NSString *)imagePathForPhoto:(Photo *)photo
{
    //首先,需要获取沙盒路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //拼接文件夹
    NSString *fileString = [path stringByAppendingPathComponent:[self fileStringForPhoto:photo]];
    
    BOOL isDirectory;
    if(![[self defaultManager] fileExistsAtPath:fileString isDirectory:&isDirectory])
    {
        NSError *error = nil;
        if ([[self defaultManager] createDirectoryAtPath:fileString withIntermediateDirectories:YES attributes:nil error:&error])
        {
            NSLog(@"%@文件夹创建成功", fileString);
        }
        else
        {
            NSLog(@"%@",error.localizedDescription);
        }
    }
    // 拼接图片名为".png"的路径
    NSString *imageFilePath = [fileString stringByAppendingPathComponent:photo.photoName];
    return imageFilePath;
}

+ (NSString *)fileStringForPhoto:(Photo *)photo
{
   return [[NSString stringWithFormat:@"项目：%@", photo.projectID] stringByAppendingPathComponent:photo.kind];
}
@end
