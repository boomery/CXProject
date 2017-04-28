//
//  ProgressImageView.m
//  MHProject
//
//  Created by ZhangChaoxin on 15/8/19.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "UploadImageView.h"
@interface UploadImageView () <ImageModelDelegate>

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIButton *reUploadButton;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end

@implementation UploadImageView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = YES;
        
        UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [self addSubview:maskView];
        maskView.backgroundColor = [UIColor blackColor];
        maskView.alpha = 0.5;
        _maskView = maskView;
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initForAutoLayout];
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [self addSubview:indicator];
        [indicator autoCenterInSuperview];
        [indicator startAnimating];
        _indicator = indicator;
        indicator.hidden = YES;
        
        UIButton *reUploadButton = [[UIButton alloc] initForAutoLayout];
        [reUploadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [reUploadButton addTarget:self action:@selector(reUploadButtonClick) forControlEvents:UIControlEventTouchUpInside];
        reUploadButton.titleLabel.font = [UIFont systemFontOfSize:10];
        reUploadButton.titleLabel.numberOfLines = 0;
        [reUploadButton setTitle:@"上传失败，点击重新上传" forState:UIControlStateNormal];
        [self addSubview:reUploadButton];
        [reUploadButton autoSetDimensionsToSize:CGSizeMake(80, 40)];
        [reUploadButton autoCenterInSuperview];
        self.reUploadButton = reUploadButton;
        reUploadButton.hidden = YES;
    }
    return self;
}

- (void)showActivity
{
    [self.indicator startAnimating];
    self.indicator.hidden = NO;
}

- (void)hideActivity
{
    [self.indicator stopAnimating];
    self.indicator.hidden = YES;
}

- (void)showError
{
    self.reUploadButton.hidden = NO;
}

- (void)hideError
{
    self.reUploadButton.hidden = YES;
}

- (void)reUploadButtonClick
{
    [self.model startUpload];
    [self setImageViewWithState:self.model.state];
}

- (void)setModel:(ImageModel *)model
{
    _model = model;
    if (model)
    {
        model.delegate = self;
        [model startUpload];
    }
    [self setImageViewWithState:model.state];
}

#pragma mark - ImageModelDelegate  Success or Fail
- (void)updateState:(ImageModelState)state
{
    self.model.state = state;
    [self setImageViewWithState:state];
}
- (void)updateProgress:(float)progress
{
//    [self.maskView frameSet:@"h" value:self.height * (1-progress)];
}

#pragma mark - 
- (void)setImageViewWithState:(ImageModelState)state
{
    switch (state)
    {
        case ImageModelStateNotUpload:
        {
            self.maskView.hidden = NO;
            [self hideActivity];
            [self hideError];
        }
            break;
        case ImageModelStateUploading:
        {
            self.maskView.hidden = NO;
            [self showActivity];
            [self hideError];
        }
            break;
        case ImageModelStateUploadSuccess:
        {
            self.maskView.hidden = YES;
            [self hideError];
            [self hideActivity];
        }
            break;
        case ImageModelStateUploadFail:
        {
            self.maskView.hidden = NO;
            [self showError];
            [self hideActivity];
        }
            break;
        default:
        {
            
        }
            break;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
