//
//  FileCell.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/1.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "FileCell.h"

@implementation FileCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.imageButton setContentEdgeInsets:UIEdgeInsetsMake(self.imageButton.height/4 - 20, 0, 0, 0)];
}

@end
