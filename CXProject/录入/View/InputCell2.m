//
//  InputCell2.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/7.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "InputCell2.h"

@implementation InputCell2

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIView *lineView = [UIView newAutoLayoutView];
    lineView.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.88 alpha:1.00];
    [self addSubview:lineView];
    [lineView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
    [lineView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
    [lineView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
    [lineView autoSetDimension:ALDimensionHeight toSize:0.5];
    
    UIView *lineView2 = [UIView newAutoLayoutView];
    lineView2.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.88 alpha:1.00];
    [self addSubview:lineView2];
    [lineView2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
    [lineView2 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
    [lineView2 autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
    [lineView2 autoSetDimension:ALDimensionHeight toSize:0.5];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
