//
//  Risk_Progress_PhotoViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/6.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "Risk_Progress_PhotoViewController.h"
#import "ImageViewCell.h"
#import "Photo+Addtion.h"
#import "Risk_Progress_DetailViewController.h"
@interface Risk_Progress_PhotoViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, DZNEmptyDataSetSource>

@property (nonatomic, strong)  UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *sourceArray;
@property (nonatomic, strong) NSMutableDictionary *arrayDict;

@end

@implementation Risk_Progress_PhotoViewController

static NSString *fileCellIdentifier = @"ImageViewCell";
static NSString *headerIdentifier = @"sectionHeader";
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
//    [self initData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initData];
}

- (void)initData
{
    _sourceArray = [[NSMutableArray alloc] init];
    _arrayDict = [[NSMutableDictionary alloc] init];
    if (self.kind)
    {
        self.sourceArray = [Photo unsortedPhotosForProjectID:[User editingProject].fileName kind:self.kind];
        [self.collectionView reloadData];
    }
    else if (_event.events.count >0)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            for (int i = 0; i < _event.events.count; i++)
            {
                Event *event = _event.events[i];
                [Photo photosForProjectID:[User editingProject].fileName item:_event.name subItem:event.name completionBlock:^(NSMutableArray *resultArray) {
                    if (resultArray.count > 0)
                    {
                        [_arrayDict setValue:resultArray forKey:[NSString stringWithFormat:@"%d",i]];
                    }
                }];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        });

    }
}

- (void)initViews
{
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 64, self.view.width-20, self.view.height - 64) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.emptyDataSetSource = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[ImageViewCell class] forCellWithReuseIdentifier:fileCellIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.kind)
    {
        return 1;
    }
    return [_arrayDict allKeys].count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.kind)
    {
        return _sourceArray.count;
    }
    else
    {
        NSArray *array = [_arrayDict valueForKey:[_arrayDict allKeys][section]];
        return array.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:fileCellIdentifier forIndexPath:indexPath];
    Photo *photo = nil;

    if (self.kind)
    {
        photo = self.sourceArray[indexPath.row];

    }
    else
    {
        NSArray *array = [_arrayDict valueForKey:[_arrayDict allKeys][indexPath.section]];
        photo = array[indexPath.row];
    }
    
    cell.photo = photo;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Risk_Progress_DetailViewController *detailVC = [[Risk_Progress_DetailViewController alloc] init];
    Photo *photo = nil;
    
    if (self.kind)
    {
        photo = self.sourceArray[indexPath.row];
        //
        detailVC.photoArray = self.sourceArray;
        photo.tag = indexPath.row;
    }
    else
    {
        NSArray *photoArray = [_arrayDict valueForKey:[_arrayDict allKeys][indexPath.section]];
        photo = photoArray[indexPath.row];
        //
        NSArray *arraies = [_arrayDict allValues];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (NSArray *a in arraies)
        {
            [arr addObjectsFromArray:a];
        }
        detailVC.photoArray = arr;
        photo.tag = [detailVC.photoArray indexOfObject:photo];
    }
    detailVC.photo = photo;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(DEF_SCREEN_WIDTH, 44);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
    [view removeAllSubviews];
    
    UILabel *titleLabel = [UILabel newAutoLayoutView];
    [view addSubview:titleLabel];
    [titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:view];
    [titleLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:view];
    [titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:view withOffset:5];
    [titleLabel autoSetDimension:ALDimensionHeight toSize:40];

    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.00];
    titleLabel.layer.cornerRadius = 5;
    titleLabel.clipsToBounds = YES;
    titleLabel.textColor = [UIColor whiteColor];
    if (!self.kind)
    {
        NSInteger index = [[_arrayDict allKeys][indexPath.section] integerValue];
        Event *event = _event.events[index];
        titleLabel.text = event.name;
    }
    
//    UIView *lineView = [UIView newAutoLayoutView];
//    lineView.backgroundColor = [UIColor colorWithRed:0.42 green:0.63 blue:0.91 alpha:1.00];
//    [view addSubview:lineView];
//    [lineView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:view];
//    [lineView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:view];
//    [lineView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleLabel withOffset:0];
//    [lineView autoSetDimension:ALDimensionHeight toSize:5];
    return view;
}

#pragma mark - UICollectionViewDelegateFlowLayout
//定义每个Cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.width - 4*15)/2.0, (self.view.width - 4*15)/2.0);
}

//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);//分别为上、左、下、右
}

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = [NSString stringWithFormat:@"没有相关%@可查看",@"数据"];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
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
