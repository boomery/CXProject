//
//  ProjectCell.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/1.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "ProjectCell.h"

@implementation ProjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setProject:(Project *)project
{
    _project = project;
    _districtLabel.text = project.district;
    _nameLabel.text = project.name;
    _addressLabel.text = project.address;
    _siteLabel.text = project.site;
    _measureDataLabel.text = project.measure_date;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
