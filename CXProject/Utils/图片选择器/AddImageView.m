//
//  AddImageView.m
//  MHProject
//
//  Created by ZhangChaoxin on 15/8/13.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "AddImageView.h"
#import "PhotoCell.h"
#import "ImageModel.h"
@interface AddImageView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@end

@implementation AddImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:layout];
        [self addSubview:self.collectionView];
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.clipsToBounds = NO;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"tribeMember"];
    }
    return self;
}

- (void)setModelArray:(NSMutableArray *)modelArray
{
    _modelArray = *&modelArray;
    [self.collectionView reloadData];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_modelArray.count == 0)
    {
        return 1;
    }
    if (_modelArray.count == 5)
    {
        return _modelArray.count;
    }
    return _modelArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tribeMember" forIndexPath:indexPath];
    if (indexPath.row == _modelArray.count)
    {
        cell.uploadImageView.model = nil;
        cell.uploadImageView.image = [UIImage imageNamed:@"add_image"];
        cell.uploadImageView.maskView.hidden = YES;
        cell.deleteButton.hidden = YES;
        cell.uploadImageView.contentMode = UIViewContentModeScaleToFill;
        cell.deleteButton.model = nil;
    }
    else
    {
        ImageModel *model = _modelArray[indexPath.row];
        cell.uploadImageView.model = model;
        cell.uploadImageView.image = model.image;
        cell.deleteButton.hidden = NO;
        cell.uploadImageView.contentMode = UIViewContentModeScaleToFill;
        cell.deleteButton.model = model;
    }
    [cell.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _modelArray.count)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickAddButton)])
        {
            [self.delegate didClickAddButton];
            return;
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(addImageView:didSelectedAtIndexPath:)])
    {
        [self.delegate addImageView:self didSelectedAtIndexPath:indexPath];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,20,0,0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}

- (void)deleteButtonClick:(ModelButton *)button
{
 
    NSInteger index = [_modelArray indexOfObject:button.model];
    [_modelArray removeObjectAtIndex:index];

    @try {
        //当图片个数为五张时，删除一张后由于加号的存在，代理返回的num总数没有变化，导致方法出错。所以此时不使用单张删除的方法
        if (_modelArray.count == 4) {
            [self.collectionView reloadData];
            return;
        }
        [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        
    }
//    if (self.delegate && [self.delegate respondsToSelector:@selector(addImageView:didDeleteAtIndexPath:)])
//    {
//        [self.delegate addImageView:self didDeleteAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:0]];
//    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
