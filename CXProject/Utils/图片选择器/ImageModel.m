//
//  ImageModel.m
//  MHProject
//
//  Created by ZhangChaoxin on 15/8/13.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "ImageModel.h"
//#import "ASIFormDataRequest.h"
//@interface ImageModel ()<ASIProgressDelegate>
@interface ImageModel ()
@end
@implementation ImageModel

- (id)copyWithZone:(NSZone *)zone
{
    ImageModel *model = [[[self class] alloc] init];
    model.image = [self.image copy];
    model.imageKey = [self.imageKey copy];
    return model;
}
- (BOOL)startUpload
{
    if (!self.image)
    {
        NSAssert(self.image, @"image为空");
    }
    if (self.state == ImageModelStateNotUpload || self.state == ImageModelStateUploadFail)
    {
        self.state = ImageModelStateUploading;
        /*
        NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
        NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
        NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
        NSString *url = DEF_API_UserUploadImage;
        NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
        NSString *str = [NSString stringWithFormat:@"%@?uid=%@&timestamp=%@&sign=%@",url,uid,timeStamp,sign];
        NSURL *completeUrl = [NSURL URLWithString:str];
        
        ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:completeUrl];
        request.showAccurateProgress = YES;
        __weak ASIFormDataRequest *weakRequest = request;
        [request setPostFormat:ASIMultipartFormDataPostFormat];
        [request setRequestMethod:@"POST"];
        
        NSData *imgData = UIImageJPEGRepresentation(self.image, 0.3);
        
        float length = imgData.length;
        
        float folderSize = 0.0;
        folderSize =length/(1024.0*1024.0);
        [request addData:imgData withFileName:@"file" andContentType:@"image/png" forKey:@"body"];
        //        [request addData:imgData forKey:@"file"];
        [request setCompletionBlock:^{
            NSString *responseString = [[NSString alloc] initWithData:weakRequest.responseData
                                                             encoding:NSUTF8StringEncoding];
            id returnData = [JsonManager JSONValue:responseString];
            NSDictionary *dict = returnData;
            NSString *ret = dict[@"ret"];
            NSString *msg = dict[@"msg"];
            if ([ret isEqualToString:@"0"])
            {
                NSDictionary *dataDict = dict[@"data"];
                NSString *imageKey = dataDict[@"key"];
                NSString *imageKeyStr = [NSString stringWithFormat:@",%@",imageKey];
                self.imageKey = imageKeyStr;
                self.state = ImageModelStateUploadSuccess;
                if (self.delegate && [self.delegate respondsToSelector:@selector(updateState:)])
                {
                    [self.delegate updateState:ImageModelStateUploadSuccess];
                }
            }
            else
            {
                self.state = ImageModelStateUploadFail;
                if (self.delegate && [self.delegate respondsToSelector:@selector(updateState:)])
                {
                    [self.delegate updateState:ImageModelStateUploadFail];
                }
                SHOW_ALERT(msg);
            }
            
        }];
        [request setUploadProgressDelegate:self];
        [request setFailedBlock:^{
            self.state = ImageModelStateUploadFail;
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateState:)])
            {
                [self.delegate updateState:ImageModelStateUploadFail];
            }
//            SHOW_ALERT(@"亲，上传失败，请检查网络并重新上传");
        }
         ];
        [request startAsynchronous];
         */
        return YES;
    }
    return NO;
}

- (void)setProgress:(float)newProgress
{
    self.uploadProgress = newProgress;
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateProgress:)])
    {
        [self.delegate updateProgress:newProgress];
    }
    NSLog(@"%f",newProgress);
}
@end
