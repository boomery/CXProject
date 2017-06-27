//
//  DetailMeasureCell.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/5/22.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "DetailMeasureCell.h"
#import "MeasureResult+Addtion.h"
@implementation DetailMeasureCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.font = LABEL_FONT;
    self.textLabel.numberOfLines = 0;
    self.textLabel.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected)
    {
        self.backgroundColor = [UIColor colorWithRed:0.30 green:0.69 blue:0.97 alpha:1.00];
        self.nameLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        self.backgroundColor = [UIColor whiteColor];
        self.nameLabel.textColor = [UIColor blackColor];
    }
}

- (void)setSubEvent:(Event *)subEvent
{
    _subEvent = subEvent;
    self.nameLabel.text = subEvent.name;
    NSInteger total = [MeasureResult numOfDesignResultsForProjectID:[User editingProject].fileName itemName:_event.name subItemName:subEvent.name];
    NSInteger now = [MeasureResult numOfResultsForProjectID:[User editingProject].fileName itemName:_event.name subItemName:subEvent.name];
    self.progressLabel.text = [NSString stringWithFormat:@"%ld/%ld", now, total];
    float scale = now/(float)total;
    if (now == 0)
    {
        _widthConstraint.constant = 0;
    }
    else
    {
        _widthConstraint.constant = self.width*scale;
    }
}
@end
