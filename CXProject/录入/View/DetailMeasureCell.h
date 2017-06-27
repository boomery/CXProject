//
//  DetailMeasureCell.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/5/22.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailMeasureCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@property (nonatomic, strong) Event *event;
@property (nonatomic, strong) Event *subEvent;
@end
