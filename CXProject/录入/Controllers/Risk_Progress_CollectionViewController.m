//
//  Risk_Progress_CollectionViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/5.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "Risk_Progress_CollectionViewController.h"
#import "FileCell.h"
#import "Risk_Progress_PhotoViewController.h"
#import "Photo+Addtion.h"
@interface Risk_Progress_CollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, DZNEmptyDataSetSource>

@property (nonatomic, strong)  UICollectionView *collectionView;

@end

@implementation Risk_Progress_CollectionViewController

static NSString *fileCellIdentifier = @"FileCell";
static NSString *headerIdentifier = @"sectionHeader";
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
}

- (void)initViews
{
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
    self.automaticallyAdjustsScrollViewInsets = YES;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    if (self.isShort)
    {
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, self.view.width-20, self.view.height-50-64) collectionViewLayout:layout];

    }
    else
    {
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, self.view.width-20, self.view.height) collectionViewLayout:layout];
    }
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
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_showUnsorted)
    {
        return _sourceArray.count + 1;
    }
    return _sourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:fileCellIdentifier forIndexPath:indexPath];
    if (self.sourceArray.count > indexPath.row)
    {
        Event *event = self.sourceArray[indexPath.row];
        cell.nameLabel.text = event.name;
        [Photo countPhotoForProjectID:[User editingProject].fileName kind:[Photo textKindForIndex:self.index] item:event.name completionBlock:^(NSString *index) {
            [cell.circleButton setTitle:index forState:UIControlStateNormal];
        }];
    }
    else
    {
        cell.nameLabel.text = @"未分类";
        [Photo countPhotoForProjectID:[User editingProject].fileName kind:[Photo textKindForIndex:self.index] item:@"" completionBlock:^(NSString *index) {
            [cell.circleButton setTitle:index forState:UIControlStateNormal];
        }];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.sourceArray.count > indexPath.row)
    {
//        Event *event = self.sourceArray[indexPath.row];
//        Risk_Progress_CollectionViewController *collection = [[Risk_Progress_CollectionViewController alloc] init];
//        collection.title = event.name;
//        collection.sourceArray = event.events;
//        [self.navigationController pushViewController:collection animated:YES];
        Event *event = self.sourceArray[indexPath.row];
        Risk_Progress_PhotoViewController *photoVC = [[Risk_Progress_PhotoViewController alloc] init];
        photoVC.title =event.name;
        photoVC.event = event;
        [self.navigationController pushViewController:photoVC animated:YES];
        
    }
    else
    {
        Risk_Progress_PhotoViewController *photoVC = [[Risk_Progress_PhotoViewController alloc] init];
        photoVC.title = @"未分类";
        photoVC.kind = [Photo textKindForIndex:self.index];
        [self.navigationController pushViewController:photoVC animated:YES];
    }
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
    return CGSizeMake((self.view.width - 4*15)/2.0, (self.view.width - 4*15)/2.0 *97/122.0 + 30);
}

//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);//分别为上、左、下、右
}

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = [NSString stringWithFormat:@"没有相关%@可查看",@"分类"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
