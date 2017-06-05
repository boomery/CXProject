//
//  M_CollectionViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/2.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "M_CollectionViewController.h"
#import "FileCell.h"
@interface M_CollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, DZNEmptyDataSetSource>
@property (nonatomic, strong)  UICollectionView *collectionView;

@end

@implementation M_CollectionViewController

static NSString *fileCellIdentifier = @"FileCell";
static NSString *headerIdentifier = @"sectionHeader";
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initViews];
}
- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%f",self.view.height);
}

- (void)initViews
{
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, self.view.width-20, self.view.height - 54 - 64) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.emptyDataSetSource = self;
    [self.view addSubview:self.collectionView];
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:@"FileCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:fileCellIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _sourceArray.count / 3.0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _sourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:fileCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(DEF_SCREEN_WIDTH, 5);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
    UIView *lineView = [UIView newAutoLayoutView];
    lineView.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.88 alpha:1.00];
    [view addSubview:lineView];
    [lineView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:view];
    [lineView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:view];
    [lineView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:view];
    [lineView autoSetDimension:ALDimensionHeight toSize:0.5];
    return view;
}

#pragma mark - UICollectionViewDelegateFlowLayout
//定义每个Cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.width - 4*15)/3.0, (self.view.width - 4*15)/3.0 + 40);
}

//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);//分别为上、左、下、右
}

//    //这个是两行cell之间的间距（上下行cell的间距）
//    - (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;

//    //两个cell之间的间距（同一行的cell的间距）
//    - (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    if (!self.fileType)
    {
        self.fileType = @"数据";
    }
    NSString *text = [NSString stringWithFormat:@"没有相关%@",self.fileType];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"M_smile"];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -100;
}
@end
