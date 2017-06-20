
//
//  SelectionView.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/20.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "SelectionView.h"
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
+ (void)showInView:(UIView *)view delegate:(id <SelectionViewDelegate>)delegate
{
    SelectionView *sharedView = [self sharedView];
    sharedView.bgView.frame = CGRectMake(0, view.height - 60, view.width, 60);
    if (!sharedView.bgView)
    {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, view.height - 60, view.width, 60)];
        bgView.backgroundColor = [UIColor whiteColor];
        sharedView.bgView = bgView;
        
        UIButton *selectAllButton = [[UIButton alloc] initForAutoLayout];
        [bgView addSubview:selectAllButton];
        [selectAllButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:bgView withOffset:-10];
        
        UIButton *uploadButton = [[UIButton alloc] initForAutoLayout];
        [bgView addSubview:uploadButton];
        
        NSArray *array = @[selectAllButton, uploadButton];
        
        [array autoSetViewsDimension:ALDimensionHeight toSize:40];
        [array autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:20.0 insetSpacing:YES matchedSizes:YES];
        
        selectAllButton.layer.cornerRadius = 10;
        selectAllButton.clipsToBounds = YES;
        selectAllButton.backgroundColor = [UIColor colorWithRed:0.27 green:0.63 blue:0.96 alpha:1.00];
        [selectAllButton setTitle:@"全选" forState:UIControlStateNormal];
        [selectAllButton addTarget:self action:@selector(selectAll) forControlEvents:UIControlEventTouchUpInside];
        
        uploadButton.layer.cornerRadius = 10;
        uploadButton.clipsToBounds = YES;
        uploadButton.backgroundColor = [UIColor colorWithRed:0.27 green:0.63 blue:0.96 alpha:1.00];
        [uploadButton setTitle:@"上传" forState:UIControlStateNormal];
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
