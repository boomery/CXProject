//
//  TopBarView.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/3/23.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "TopBarView.h"
@interface TopBarView ()
{
    CALayer *_lineLayer;
    UIButton *_sortButton;
}
@end
@implementation TopBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //画下划线
        CALayer *lineLayer = [[CALayer alloc] init];
        lineLayer.frame = CGRectMake(0, self.bottom-0.5, self.width, 0.5);
        lineLayer.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.00].CGColor;
        [self.layer addSublayer:lineLayer];
        _lineLayer = lineLayer;
        
        UIButton *sortButton = [[UIButton alloc] initForAutoLayout];
        [self addSubview:sortButton];
        [sortButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:50];
        [sortButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
        [sortButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
        [sortButton autoSetDimension:ALDimensionWidth toSize:100];
        [sortButton setTitle:@"综合排序" forState:UIControlStateNormal];
        [sortButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sortButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sortButton setTitleColor:[UIColor colorWithRed:0.93 green:0.36 blue:0.16 alpha:1.00] forState:UIControlStateSelected];
        [sortButton addTarget:self action:@selector(sortButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _sortButton = sortButton;
       
    }
    return self;
}

- (void)sortButtonClicked:(UIButton *)sortButton
{
    
}

- (void)layoutSubviews
{
    _lineLayer.frame = CGRectMake(0, self.bottom-0.5, self.width, 0.5);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
