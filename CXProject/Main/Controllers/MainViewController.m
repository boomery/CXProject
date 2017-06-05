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
#import "ImageViewController.h"
@interface MainViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, PageViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *partnerArray;
@property (nonatomic, strong) NSDictionary *imageNameDict;
@property (nonatomic, assign) CGFloat space;
@end

@implementation MainViewController

static NSString *imageCellIdentifier = @"ImageViewCell";
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpViews];
    [self initData];
}

- (void)initData
{
    _titleArray = @[@"关于平大", @"业务范围", @"项目展示", @"合作伙伴"];
    _imageNameDict = @{@"0":@[@"home_introduce", @"home_concept", @"home_advantage"], @"1":@[@"home_measure", @"home_train", @"home_service"], @"2":@[@"home_house", @"home_business", @"home_public", @"home_industry"]};
    _partnerArray = @[@"wk", @"wd", @"bl", @"ccjs", @"hr", @"ln", @"zjdc", @"zjsj", @"dj", @"more"];
}

- (void)setUpViews
{
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
        pageView.tag = section;
        pageView.delegate = self;
        pageView.backgroundColor = [UIColor redColor];
        pageView.imageArray = _imageNameDict[[NSString stringWithFormat:@"%ld",section]];
        pageView.duration = 0;
        [view addSubview:pageView];
    }
    else
    {
        for (int i = 0; i < _partnerArray.count; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat width = (self.view.width - 4*_space)/3.0;
            CGFloat height = self.view.width/3.0*50/160.0;
            button.tag = i;
            button.layer.borderWidth = 0.5;
            button.layer.borderColor = [UIColor colorWithRed:0.73 green:0.73 blue:0.73 alpha:1.00].CGColor;
            
            button.frame = CGRectMake(_space + i%3*(width + _space), _space + i/3*(height + _space), width, height);
            [view addSubview:button];
            [button setBackgroundImage:[UIImage imageNamed:_partnerArray[i]] forState:UIControlStateNormal];
        }
      
        
        if (!_collectionView)
        {
//            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//            layout.itemSize = CGSizeMake(self.view.width/3.0-10, self.view.width/3.0*50/160.0);
//            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width/710.0 * 250) collectionViewLayout:layout];
//            _collectionView.backgroundColor = [UIColor whiteColor];
//            _collectionView.delegate = self;
//            _collectionView.scrollEnabled = NO;
//            _collectionView.dataSource = self;
//            [_collectionView registerClass:[ImageViewCell class] forCellWithReuseIdentifier:imageCellIdentifier];
        }
//        [view addSubview:_collectionView];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3)
    {
        _space = 15;
        CGFloat height = self.view.width/3.0*50/160.0 + _space;
        return (_partnerArray.count/3.0 + 1)*height;
    }
    return self.view.width/710.0 * 250;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageCellIdentifier forIndexPath:indexPath];
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = [UIColor colorWithRed:0.73 green:0.73 blue:0.73 alpha:1.00].CGColor;
    cell.imageView.image = [UIImage imageNamed:_partnerArray[indexPath.row]];
    if (indexPath.row == _partnerArray.count)
    {
        _collectionView.frame =CGRectMake(0, 0, self.view.width, _collectionView.collectionViewLayout.collectionViewContentSize.height);
    }
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

#pragma mark - PageViewDelegate
- (void)pageView:(PageView *)pageView didSelectPageViewWithNumber:(NSInteger)selectNumber
{
    ImageViewController *imageVC = [[ImageViewController alloc] init];
    imageVC.hidesBottomBarWhenPushed = YES;

    if (pageView.tag == 0)
    {
        switch (selectNumber)
        {
            case 0:
            {
                imageVC.title = @"公司简介";
                imageVC.imageName = @"introduce";
            }
                break;
            case 1:
            {
                imageVC.title = @"公司理念";
                imageVC.imageName = @"concept";
            }
                break;
            case 2:
            {
                imageVC.title = @"核心优势";
                imageVC.imageName = @"advantage";
            }
                break;
                
            default:
                break;
        }
    }
    else if (pageView.tag == 1)
    {
        switch (selectNumber)
        {
            case 0:
            {
                imageVC.title = @"第三方评估";
                imageVC.imageName = @"third_measure";
            }
                break;
            case 1:
            {
                imageVC.title = @"工程管理培训";
//                imageVC.imageName = @"concept";
            }
                break;
            case 2:
            {
                imageVC.title = @"5+2+1服务体系";
                imageVC.imageName = @"service";
            }
                break;
                
            default:
                break;
        }
    }
    else if (pageView.tag == 2)
    {
        switch (selectNumber)
        {
            case 0:
            {
                imageVC.title = @"住宅项目";
//                imageVC.imageName = @"introduce";
            }
                break;
            case 1:
            {
                imageVC.title = @"商业项目";
//                imageVC.imageName = @"concept";
            }
                break;
            case 2:
            {
                imageVC.title = @"公建项目";
//                imageVC.imageName = @"advantage";
            }
                break;
            case 3:
            {
                imageVC.title = @"工业项目";
//                imageVC.imageName = @"advantage";
            }
                break;
                
            default:
                break;
        }
    }
    [self.navigationController pushViewController:imageVC animated:YES];
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
