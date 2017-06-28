//
//  ProjectCell.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/1.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "ProjectCell.h"
@interface ProjectCell ()
@end
@implementation ProjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    self.lbgView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.lbgView.layer.shadowOffset = CGSizeMake(3, 3);
    self.lbgView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
    self.lbgView.layer.shadowRadius = 4;//阴影半径，默认3
    
    self.rbgView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.rbgView.layer.shadowOffset = CGSizeMake(3, 3);
    self.rbgView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
    self.rbgView.layer.shadowRadius = 4;//阴影半径，默认3
    // Initialization code
}

- (void)setProject:(Project *)project
{
    _project = project;
    _headImageView.image = [UIImage imageNamed:@"bl"];
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
