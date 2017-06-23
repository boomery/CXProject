//
//  UploadCell.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/20.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "UploadCell.h"
@interface UploadCell ()
@property (weak, nonatomic) IBOutlet UILabel *kindLabel;
@property (weak, nonatomic) IBOutlet UILabel *takenByLabel;
@property (weak, nonatomic) IBOutlet UILabel *uploadTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@end

@implementation UploadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPhoto:(Photo *)photo
{
    _photo = photo;
    _kindLabel.text = [NSString stringWithFormat:@"类别：%@", photo.kind];
    _uploadTimeLabel.text = [NSString stringWithFormat:@"上传时间：%@", photo.uploadTime];
    _takenByLabel.text = [NSString stringWithFormat:@"拍摄人：%@", photo.takenBy];
    if (!photo.image)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [UIImage imageWithContentsOfFile:photo.photoFilePath];
            dispatch_async(dispatch_get_main_queue(), ^{
                photo.image = image;
                self.photoImageView.image = image;
            });
        });
    }
    else
    {
        self.photoImageView.image = photo.image;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
