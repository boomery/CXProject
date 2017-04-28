//
//  WMPhotoCollectionViewCell.m
//  MHProject
//
//  Created by Andy on 15/6/6.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "WMPhotoCollectionViewCell.h"

@implementation WMPhotoCollectionViewCell

- (void)sendValue:(id)dic
{
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH / 4 - 16, DEF_SCREEN_WIDTH / 4 - 16)];
    self.imageView.image = [dic objectForKey:@"img"];
    [self.contentView addSubview:self.imageView];
    
    self.selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.imageView.width - 20,0, 20, 20)];
    [self.contentView addSubview:self.selectImageView];
    
    selectFlag = [[dic objectForKey:@"flag"] boolValue];
    if (selectFlag)
    {
        self.selectImageView.image = [UIImage imageNamed:@"image_select"];
    }
    else
    {
        self.selectImageView.image = [UIImage imageNamed:@"image_unselect"];
    }
}
- (void)setSelectFlag:(BOOL)flag
{
    selectFlag = flag;
    
    if (selectFlag)
    {
        self.selectImageView.image = [UIImage imageNamed:@"image_select"];
    } else {
        self.selectImageView.image = [UIImage imageNamed:@"image_unselect"];
    }
}

@end
