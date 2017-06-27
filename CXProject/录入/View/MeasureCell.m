//
//  MeasureCell.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/20.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "MeasureCell.h"
#import "MeasureResult+Addtion.h"
@interface MeasureCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;

@end
@implementation MeasureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setEvent:(Event *)event
{
    _event = event;
    self.uploadTimeLabel.text = @"无上传记录";
    self.nameLabel.text = event.name;
    
    NSString *uploadTime = [MeasureResult tUploadTimeForProjectID:[User editingProject].fileName itemName:event.name];
    if (uploadTime.length != 0)
    {
        self.uploadTimeLabel.text = [NSString stringWithFormat:@"上次上传时间:%@",uploadTime];
    }
    
    NSInteger results = [MeasureResult tNumOfResultsForProjectID:[User editingProject].fileName itemName:event.name];
    NSInteger qualified = [MeasureResult tNumOfQualifiedForProjectID:[User editingProject].fileName itemName:event.name];
    if (results != 0)
    {
        self.qualifiedLabel.text = [NSString stringWithFormat:@"合格率:%.0f%%", (float)qualified/results*100];
    }
    else
    {
        self.qualifiedLabel.text = @"合格率";
    }
}

- (void)setIsMultiSelect:(BOOL)isMultiSelect
{
    _isMultiSelect = isMultiSelect;
    
    //非多选
    if (!_isMultiSelect)
    {
        _leftConstraint.constant = 0;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    //多选模式
    else
    {
        _leftConstraint.constant = 25;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectButton.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
