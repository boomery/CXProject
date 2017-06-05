//
//  MyProjectCell.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/1.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "MyProjectCell.h"
@interface MyProjectCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
@implementation MyProjectCell

- (void)setProject:(Project *)project
{
    _project = project;
    _nameLabel.text = project.name;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
