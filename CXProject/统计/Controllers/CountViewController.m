//
//  CountViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/3/22.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "CountViewController.h"
#import "ResultViewController.h"
#import "CountCell.h"
#import "TopBarView.h"
#import "DataModel.h"
#define BEGIN_Y 20.0
#define TopBar_HEIGHT 44.0

@interface CountViewController ()<UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate,UITableViewDelegate, UITableViewDataSource>
{
    //界面相关
    UISearchBar *_searchBar;
    UISearchController *_searchController;
    TopBarView *_topBarView;
    //临时数据源
    NSMutableArray *_tempArray;
    NSMutableArray *_resultArray;
}
@end

@implementation CountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.definesPresentationContext = YES;
    [self initViews];
    [self createTempData];
}

- (void)createTempData
{
    _tempArray = [[NSMutableArray alloc] init];
    _resultArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 20; i++)
    {
        DataModel *model = [[DataModel alloc] init];
        model.name = [NSString stringWithFormat:@"项目%d",i];
        model.desc = [NSString stringWithFormat:@"排名:%d",i];
        [_tempArray addObject:model];
    }
}

- (void)initViews
{
    ResultViewController *resultVC = [[ResultViewController alloc] init];
    UINavigationController *resultNav = [[UINavigationController alloc] initWithRootViewController:resultVC];
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:resultNav];
    searchController.searchResultsUpdater = self;
    searchController.searchBar.placeholder = @"请输入你要查找的项目名称";
    _searchController = searchController;
    
    _searchBar = searchController.searchBar;
    [self.view addSubview:searchController.searchBar];
    searchController.searchBar.delegate = self;
}

#pragma mark - 横屏布局
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [_searchBar setWidth:size.width];
    [_topBarView setWidth:size.width];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    UINavigationController *nav = (UINavigationController *)searchController.searchResultsController;
    ResultViewController *resultVC = (ResultViewController *)nav.topViewController;
    resultVC.resultArray = _resultArray;
    [resultVC.tableView reloadData];
}

- (NSArray *)resultArrayWithSearchText:(NSString *)text
{
    [_resultArray removeAllObjects];
    for (DataModel *model in _tempArray)
    {
        NSRange range = [model.name rangeOfString:text];
        if (range.location != NSNotFound)
        {
            [_resultArray addObject:model];
        }
    }
    return _resultArray;
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [_topBarView tableViewAnimateShouldShow:NO];
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self resultArrayWithSearchText:searchText];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    return _tempArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CountCell";
    CountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[CountCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    DataModel *model = [_tempArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.desc;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }
    else
    {
        if (!_topBarView)
        {
            _topBarView = [[TopBarView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, TopBar_HEIGHT)];
            _topBarView.offSet = TopBar_HEIGHT;
            _topBarView.titleArray = @[@"综合排序",@"横竖屏切换",@"筛选:"];
        }
        return _topBarView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    return TopBar_HEIGHT;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_searchBar endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y == -64)
    {
        _topBarView.offSet = TopBar_HEIGHT;
    }
}

//搜索框要么显示要么隐藏，不然会出现显示错位
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y < -64 + 44/2)
    {
        _topBarView.offSet = TopBar_HEIGHT;
        [UIView animateWithDuration:0.2 animations:^{
            scrollView.contentOffset = CGPointMake(0, -64);
        }];
    }
    else if (scrollView.contentOffset.y < -20)
    {
        _topBarView.offSet = 0;
        [UIView animateWithDuration:0.2 animations:^{
            scrollView.contentOffset = CGPointMake(0, -20);
        }];
    }
    else
    {
        _topBarView.offSet = 0;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
