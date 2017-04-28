//
//  WMPhotoPickerController.h
//  MHProject
//
//  Created by Andy on 15/6/6.
//  Copyright (c) 2015年 Andy. All rights reserved.
//
#import "BaseViewController.h"
#import <UIKit/UIKit.h>

@protocol WMPhotoPickerDelegate <NSObject>

- (void)getPhoto:(NSArray *)imageArray;

@end


@interface WMPhotoPickerController : BaseViewController<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
//本地图片
@property (nonatomic, strong) UICollectionView *myCollectionView;
//完成按钮
@property (nonatomic, strong) UIButton *OKBtn;
//图片
@property (nonatomic, strong) UIImageView *countImageView;
//数量
@property (nonatomic, strong) UIButton *countLab;
//代理
@property (nonatomic, assign) id<WMPhotoPickerDelegate> delegate;
//所有图片数组
@property (nonatomic, strong) NSMutableArray *photoImages;
@property (nonatomic, strong) NSMutableArray *selectedImages;
@property (nonatomic, assign) NSInteger selectedCount;
@end
