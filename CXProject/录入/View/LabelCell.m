//
//  LabelCell.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/10.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "LabelCell.h"

@implementation LabelCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    // Initialization code
}

@end
