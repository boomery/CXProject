//
//  LabelReusableView.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/5/17.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "LabelReusableView.h"
@interface LabelReusableView ()
{
    UILabel *_titleLabel;
}
@end
@implementation LabelReusableView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UILabel *label = [[UILabel alloc] initForAutoLayout];
        [self addSubview:label];
        _titleLabel = label;
        [label autoPinEdgesToSuperviewEdges];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

@end
