//
//  AddImageView.h
//  MHProject
//
//  Created by ZhangChaoxin on 15/8/13.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddImageView : UIView

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, weak) id delegate;

@end

@protocol AddImageViewDelegate <NSObject>

- (void)addImageView:(AddImageView *)addImageView didSelectedAtIndexPath:(NSIndexPath *)indexPath;
- (void)addImageView:(AddImageView *)addImageView didDeleteAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (void)didClickAddButton;
@end