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
        [self addSubview:imageView];
        [imageView autoPinEdgesToSuperviewEdges];
        _imageView = imageView;
    }
    return self;
}

@end
