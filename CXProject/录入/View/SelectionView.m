
//
//  SelectionView.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/20.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "SelectionView.h"
@interface SelectionView()
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@end

static SelectionView *sharedView = nil;

@implementation SelectionView

+ (instancetype)sharedView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedView = [self new];
    });
    return sharedView;
}

+ (void)showInView:(UIView *)view leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle delegate:(id <SelectionViewDelegate>)delegate
{
    SelectionView *sharedView = [self sharedView];
    sharedView.bgView.frame = CGRectMake(0, view.height - 60, view.width, 60);
    [sharedView.leftButton setTitle:leftTitle forState:UIControlStateNormal];
    [sharedView.rightButton setTitle:rightTitle forState:UIControlStateNormal];
    if (!sharedView.bgView)
    {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, view.height - 60, view.width, 60)];
        bgView.backgroundColor = [UIColor whiteColor];
        sharedView.bgView = bgView;
        
        UIButton *selectAllButton = [[UIButton alloc] initForAutoLayout];
        [bgView addSubview:selectAllButton];
        [selectAllButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:bgView withOffset:-10];
        sharedView.leftButton = selectAllButton;
        
        UIButton *uploadButton = [[UIButton alloc] initForAutoLayout];
        [bgView addSubview:uploadButton];
        sharedView.rightButton = uploadButton;
        
        NSArray *array = @[selectAllButton, uploadButton];
        
        [array autoSetViewsDimension:ALDimensionHeight toSize:40];
        [array autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:40.0 insetSpacing:YES matchedSizes:YES];
        
        selectAllButton.layer.cornerRadius = 10;
        selectAllButton.clipsToBounds = YES;
        selectAllButton.backgroundColor = [UIColor colorWithRed:0.27 green:0.63 blue:0.96 alpha:1.00];
        [selectAllButton setTitle:leftTitle forState:UIControlStateNormal];
        [selectAllButton addTarget:self action:@selector(selectAll) forControlEvents:UIControlEventTouchUpInside];
        
        uploadButton.layer.cornerRadius = 10;
        uploadButton.clipsToBounds = YES;
        uploadButton.backgroundColor = [UIColor colorWithRed:0.92 green:0.35 blue:0.17 alpha:1.00];
        [uploadButton setTitle:rightTitle forState:UIControlStateNormal];
        [uploadButton addTarget:self action:@selector(upload) forControlEvents:UIControlEventTouchUpInside];
    }
    [view addSubview:sharedView.bgView];
    sharedView.delegate = delegate;
}


+ (void)dismiss
{
    SelectionView *sharedView = [self sharedView];
    [sharedView.bgView removeFromSuperview];
    sharedView.delegate = nil;
}

+ (void)selectAll
{
    SelectionView *sharedView = [self sharedView];
    if (sharedView.delegate && [sharedView.delegate respondsToSelector:@selector(didClickSelectAll)])
    {
        [sharedView.delegate didClickSelectAll];
    }
}

+ (void)upload
{
    SelectionView *sharedView = [self sharedView];
    if (sharedView.delegate && [sharedView.delegate respondsToSelector:@selector(didClickUpload)])
    {
        [sharedView.delegate didClickUpload];
    }
}


@end
