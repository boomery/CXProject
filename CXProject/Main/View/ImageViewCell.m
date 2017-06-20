//
//  ImageViewCell.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/5/25.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "ImageViewCell.h"

@implementation ImageViewCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIImageView *imageView = [[UIImageView alloc] initForAutoLayout];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:imageView];
        [imageView autoPinEdgesToSuperviewEdges];
        _imageView = imageView;
    }
    return self;
}

- (void)setPhoto:(Photo *)photo
{
    _photo = photo;
    if (!photo.image)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [UIImage imageWithContentsOfFile:photo.photoFilePath];
            dispatch_async(dispatch_get_main_queue(), ^{
                photo.image = image;
                self.imageView.image = image;
            });
        });
    }
    else
    {
        self.imageView.image = photo.image;
    }
}
@end
