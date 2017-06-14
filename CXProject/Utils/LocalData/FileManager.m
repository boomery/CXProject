
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

+ (NSString *)imagePathForName:(NSString *)imageName
{
    //首先,需要获取沙盒路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 拼接图片名为"currentImage.png"的路径
    NSString *imageFilePath = [path stringByAppendingPathComponent:imageName];
    return imageFilePath;
}

+ (NSString *)imagePathForName:(NSString *)imageName photo:(Photo *)photo
{
    //首先,需要获取沙盒路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //拼接文件夹
    NSString *fileString = [path stringByAppendingPathComponent:[self fileStringForPhoto:photo]];
    // 拼接图片名为".png"的路径
    NSString *imageFilePath = [fileString stringByAppendingPathComponent:imageName];
    return imageFilePath;
}

+ (NSString *)fileStringForPhoto:(Photo *)photo
{
    if (!photo.item)
    {
        return [[[User editingProject].fileName stringByAppendingPathComponent:photo.kind] stringByAppendingPathComponent:@"未分类"];
    }
    return [[[User editingProject].fileName stringByAppendingPathComponent:photo.kind] stringByAppendingPathComponent:photo.item];
}

+ (BOOL)saveImage:(UIImage *)image withRatio:(CGFloat)ratio imageName:(NSString *)imageName
{
    return [UIImageJPEGRepresentation(image, ratio) writeToFile:[FileManager imagePathForName:imageName] atomically:YES];
}

+ (BOOL)deleteImageForPhotoFilePath:(NSString *)filePath
{
    NSError *error;
    return [[self defaultManager] removeItemAtPath:filePath error:&error];
}

@end
