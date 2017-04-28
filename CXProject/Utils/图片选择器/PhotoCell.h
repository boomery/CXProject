//
//  PhotoCell.h
//  Bluemobile
//
//  Created by blue on 15-4-15.
//  Copyright (c) 2015年 chenjianglin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadImageView.h"
@interface ModelButton: UIButton
@property (nonatomic, strong) ImageModel *model;
@end

@interface PhotoCell : UICollectionViewCell

@property (nonatomic, strong) UploadImageView *uploadImageView;
@property (nonatomic, strong) ModelButton *deleteButton;

@end
