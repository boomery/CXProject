//
//  MainViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/3/22.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "MainViewController.h"
#import "PageView.h"
#import "ImageViewCell.h"
@interface MainViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSDictionary *imageNameDict;
@end

@implementation MainViewController

static NSString *imageCellIdentifier = @"ImageViewCell";
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpViews];
    [self initData];
}

- (void)initData
{
    _titleArray = @[@"关于平大", @"业务范围", @"项目展示", @"合作伙伴"];
    _imageNameDict = @{@"0":@[@"introduce", @"concept", @"advantage"], @"1":@[@"home_measure", @"home_train", @"home_service"], @"2":@[@"home_house", @"home_business", @"home_public", @"home_industry"]};
}

- (void)setUpViews
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"RESULT_CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    UIView *leftLineView = [UIView newAutoLayoutView];
    [view addSubview:leftLineView];
    [leftLineView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:view withOffset:10];
    [leftLineView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [leftLineView autoSetDimensionsToSize:CGSizeMake(5, 30)];
    leftLineView.backgroundColor = [UIColor colorWithRed:0.92 green:0.20 blue:0.14 alpha:1.00];
    
    UILabel *titleLabel = [[UILabel alloc] initForAutoLayout];
    [view addSubview:titleLabel];
    [titleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:leftLineView withOffset:10];
    
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.text = _titleArray[section];
    
    UIView *bottomLineView = [UIView newAutoLayoutView];
    bottomLineView.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.88 alpha:1.00];
    [view addSubview:bottomLineView];
    [bottomLineView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:view];
    [bottomLineView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:view];
    [bottomLineView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:view];
    [bottomLineView autoSetDimension:ALDimensionHeight toSize:0.5];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    if (section != 3)
    {
        PageView *pageView = [[PageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width/710.0 * 250)];
        pageView.backgroundColor = [UIColor redColor];
        pageView.imageArray = _imageNameDict[[NSString stringWithFormat:@"%ld",section]];
        pageView.duration = 0;
        [view addSubview:pageView];
    }
    else
    {
        if (!_collectionView)
        {
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.itemSize = CGSizeMake(100, 50);
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width/710.0 * 250) collectionViewLayout:layout];
            _collectionView.backgroundColor = [UIColor whiteColor];
            _collectionView.delegate = self;
            _collectionView.dataSource = self;
            [_collectionView registerClass:[ImageViewCell class] forCellWithReuseIdentifier:imageCellIdentifier];
        }
        [view addSubview:_collectionView];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.view.width/710.0 * 250;
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 50;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageCellIdentifier forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"logo"];
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
 
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
