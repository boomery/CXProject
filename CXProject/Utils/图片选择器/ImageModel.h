//
//  ImageModel.h
//  MHProject
//
//  Created by ZhangChaoxin on 15/8/13.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, ImageModelState) {
    ImageModelStateNotUpload = 0,
    ImageModelStateUploading = 1,
    ImageModelStateUploadSuccess = 2,
    ImageModelStateUploadFail = 3,

};
@interface ImageModel : NSObject <NSCopying>

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *imageKey;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) ImageModelState state;
@property (nonatomic, assign) float uploadProgress;

- (BOOL)startUpload;

@end

@protocol ImageModelDelegate <NSObject>

- (void)updateProgress:(float)progress;
- (void)updateState:(ImageModelState)state;

@end
