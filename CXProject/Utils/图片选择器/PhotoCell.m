//
//  PhotoCell.m
//  Bluemobile
//
//  Created by blue on 15-4-15.
//  Copyright (c) 2015年 chenjianglin. All rights reserved.
//

#import "PhotoCell.h"
@implementation ModelButton
@end
@implementation PhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UploadImageView *imageView = [[UploadImageView alloc ]initWithFrame:CGRectMake(0, 0, self.width-0, self.height-0)];
        imageView.backgroundColor = [UIColor whiteColor];
        [self addSubview:imageView];
        self.uploadImageView = imageView;
        
        ModelButton *deleteButton = [[ModelButton alloc] initForAutoLayout];
        deleteButton.multipleTouchEnabled = NO;
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"ic-delet"] forState:UIControlStateNormal];
        [self addSubview:deleteButton];
        [deleteButton autoSetDimensionsToSize:CGSizeMake(40/2.0, 40/2.0)];
        [deleteButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:imageView];
        [deleteButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:imageView];
        self.deleteButton = deleteButton;
    }
    return self;
}

@end
