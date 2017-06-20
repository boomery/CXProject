//
//  ImageViewCell.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/5/25.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"
@interface ImageViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) Photo *photo;

@end
