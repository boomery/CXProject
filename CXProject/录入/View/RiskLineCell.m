//
//  RiskLineCell.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/5/12.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "RiskLineCell.h"

@implementation RiskLineCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    UIView *lineView2 = [UIView newAutoLayoutView];
    _lineView = lineView2;
    [self addSubview:lineView2];
    [lineView2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
    [lineView2 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
    [lineView2 autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
    [lineView2 autoSetDimension:ALDimensionHeight toSize:3];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (self.selected)
    {
        self.lineView.backgroundColor = [UIColor colorWithRed:0.92 green:0.20 blue:0.14 alpha:1.00];
    }
    else
    {
        self.lineView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
    }
}

@end
