//
//  WMPhotoPickerController.m
//  MHProject
//
//  Created by Andy on 15/6/6.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "WMPhotoPickerController.h"
#import "WMPhotoCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define CELL_NAME @"Cell"

@interface WMPhotoPickerController ()

@end

@implementation WMPhotoPickerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self addNavBarTitle:@"选择图片"];
//    [self addLeftNavBarBtnByImg:@"back" andWithText:@""];
    
//    [self showNavBarDefaultHUDByNavTitle:@"选择图片" inView:self.view isBack:YES];
    
    [self uiHUD];
    
}
- (void)uiHUD
{
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - 64 - 49) collectionViewLayout:flow];
    self.myCollectionView.backgroundColor = [UIColor whiteColor];
    self.myCollectionView.showsVerticalScrollIndicator = NO;
   // self.myCollectionView.delegate = self;
   // self.myCollectionView.dataSource = self;
    
    //注册
    [self.myCollectionView registerClass:[WMPhotoCollectionViewCell class] forCellWithReuseIdentifier:CELL_NAME];
    [self.view addSubview:self.myCollectionView];
    
    UIView *LineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.myCollectionView.bottom, DEF_SCREEN_WIDTH, 40)];
    LineView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [self.view addSubview:LineView];
    
    self.OKBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.OKBtn.frame = CGRectMake(LineView.width - 70, 5, 50, 30);
    [self.OKBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.OKBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.OKBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.OKBtn setBackgroundColor:THEME_COLOR];
    self.OKBtn.layer.cornerRadius = 5;
    [self.OKBtn addTarget:self action:@selector(okBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [LineView addSubview:self.OKBtn];
    
    self.countLab = [UIButton buttonWithType:UIButtonTypeCustom];
    self.countLab.frame = CGRectMake(self.OKBtn.left - 40, self.OKBtn.top, 30, 30);
    self.countLab.backgroundColor = THEME_COLOR;
    //self.countLab.hidden = YES;
    [self.countLab setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.countLab setTitle:@"0" forState:UIControlStateNormal] ;

    //self.countLab.textAlignment = DEF_TextAlignmentCenter;
    self.countLab.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.countLab.layer.cornerRadius = 15;
    [LineView addSubview:self.countLab];
    
    self.photoImages = [[NSMutableArray alloc] init];
    self.selectedImages = [[NSMutableArray alloc] init];
    ALAssetsLibrary *_assetsLibrary = [[ALAssetsLibrary alloc] init];
    ///ALAssetsGroupLibrary
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos|ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result)
            {
                //图片的url
                NSURL *url = [[result defaultRepresentation] url];
                
                //缩略图显示
                UIImage *img = [UIImage imageWithCGImage:result.thumbnail];
                
                if(img)
                {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:url forKey:@"url"];
                    [dic setObject:img forKey:@"img"];
                    [dic setObject:@"0" forKey:@"flag"];
                    [self.photoImages addObject:dic];
                }
                if(index + 1 == group.numberOfAssets)
                {
                    ///最后一个刷新界面
                    [self finish];
                }
            }
        }];
    } failureBlock:^(NSError *error) {
        // error
    }];

}
- (void)finish
{
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
}
#pragma mark UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photoImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    WMPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_NAME forIndexPath:indexPath];
    cell.selectImageView.tag = indexPath.row;
    if (indexPath.row < [self.photoImages count])
    {
        id dic = [self.photoImages objectAtIndex:indexPath.row];
        [cell sendValue:dic];
    }
    return cell;
}
#pragma mark - UICollectionViewDelegateFlowLayout
// 设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWH = DEF_SCREEN_WIDTH / 4 - 16;
    return CGSizeMake(itemWH, itemWH);
}
// 设置每个图片的Margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMPhotoCollectionViewCell *cell = (WMPhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSDictionary *dic = [self.photoImages objectAtIndex:indexPath.row];
    BOOL flag = [[dic objectForKey:@"flag"] boolValue];
    if (!flag)
    {
        if ((self.selectedImages.count+self.selectedCount) >= 5)
        {
            ALERT(@"亲，您最多只能选择五张图片");
            return;
        }
        [dic setValue:@"1" forKey:@"flag"];
        [self.selectedImages addObject:dic];
    }
    else
    {
        [dic setValue:@"0" forKey:@"flag"];
        [self.selectedImages removeObject:dic];
    }
    [cell setSelectFlag:!flag];
    
    NSInteger selectCount = self.selectedImages.count;
    [self.countLab setTitle:[NSString stringWithFormat:@"%ld", (long)selectCount] forState:UIControlStateNormal] ;

}
/**
 *  获取列表中有多少Image被选中
 *
 *  @return 选中个数
 */
- (NSInteger)getSelectImageCount
{
    NSInteger count = 0;
    for (NSInteger i = 0; i < [self.photoImages count]; i++)
    {
        id dic = [self.photoImages objectAtIndex:i];
        BOOL flag = [[dic objectForKey:@"flag"] boolValue];
        if (flag)
        {
            count++;
        }
    }

    return count;
}
- (void)okBtnAction:(UIButton *)sender
{
    //2、代理方式传递大图
    if ([self.delegate respondsToSelector:@selector(getPhoto:)])
    {
        for (int i=0; i<self.selectedImages.count; i++)
        {
            NSDictionary *dic = self.selectedImages[i];
            NSURL *imageUrl =  dic[@"url"];
            
            //从相册中选取制定url的图片
            ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
            [assetsLibrary assetForURL:imageUrl resultBlock:^(ALAsset *asset)
             {
                 ALAssetRepresentation* representation = [asset defaultRepresentation];
                 CGImageRef imageref =[representation fullScreenImage];
                 UIImage *bigImg = [UIImage imageWithCGImage:imageref];
                 
                 [dic setValue:bigImg forKey:@"img"];
                 
                 if (i == self.selectedImages.count-1)
                 {
                     [self.delegate getPhoto:self.selectedImages];
                 }
             } failureBlock:^(NSError *error) {
                 
             }];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
