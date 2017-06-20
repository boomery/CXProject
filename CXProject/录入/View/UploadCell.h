//
//  UploadCell.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/20.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"
@interface UploadCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (nonatomic, strong) Photo *photo;

@end
