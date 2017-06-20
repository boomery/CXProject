//
//  MeasureCell.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/20.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeasureCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *qualifiedLabel;
@property (weak, nonatomic) IBOutlet UILabel *uploadTime;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end
