//
//  DetailMeasureCell.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/5/22.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "DetailMeasureCell.h"

@implementation DetailMeasureCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected)
    {
        self.backgroundColor = [UIColor colorWithRed:0.36 green:0.63 blue:0.93 alpha:1.00];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.doneLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        self.backgroundColor = [UIColor whiteColor];
        self.nameLabel.textColor = [UIColor blackColor];
        self.doneLabel.textColor = [UIColor blackColor];
    }
    // Configure the view for the selected state
}

@end
