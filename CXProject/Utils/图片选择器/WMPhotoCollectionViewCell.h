//
//  WMPhotoCollectionViewCell.h
//  MHProject
//
//  Created by Andy on 15/6/6.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMPhotoCollectionViewCell : UICollectionViewCell
{
    BOOL selectFlag;
}
//
@property (nonatomic, strong) UIImageView *imageView;
//
@property (nonatomic, strong) UIImageView *selectImageView;

- (void)sendValue:(id)dic;
- (void)setSelectFlag:(BOOL)flag;
@end
