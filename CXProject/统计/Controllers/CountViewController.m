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
#define BEGIN_Y 20

@interface CountViewController ()<UISearchBarDelegate, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource>
{
    UISearchBar *_searchBar;
    TopBarView *_topBarView;
    UITableView *_tableView;
    CGFloat _lastOffsetY;
    BOOL _isAnimating;
    
    NSMutableArray *_tempArray;
    NSMutableArray *_resultArray;
}
@end

@implementation CountViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.definesPresentationContext = YES;
    [self initViews];
    [self createTempData];
}

- (void)createTempData
{
    _tempArray = [[NSMutableArray alloc] init];
    _resultArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 100; i++)
    {
        DataModel *model = [[DataModel alloc] init];
        model.name = [NSString stringWithFormat:@"项目%d",i];
        model.desc = [NSString stringWithFormat:@"排名:%d",i];
        [_tempArray addObject:model];
    }
}

- (void)initViews
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, BEGIN_Y, DEF_SCREEN_WIDTH, 40)];
    [self.view addSubview:searchBar];
    searchBar.showsCancelButton = YES;
    searchBar.placeholder = @"请输入您要查找的项目";
    searchBar.delegate = self;
    _searchBar = searchBar;
    
    ResultViewController *resultVC = [[ResultViewController alloc] init];
    UINavigationController *resultNav = [[UINavigationController alloc] initWithRootViewController:resultVC];
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:resultNav];
    searchController.searchResultsUpdater = self;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - 48 - 20) style:UITableViewStylePlain];
    [self.view insertSubview:tableView belowSubview:searchBar];
    tableView.delegate = self;
    tableView.dataSource = self;
    _tableView = tableView;
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
    [_tableView setWidth:size.width];
    [_topBarView setWidth:size.width];
    [_tableView setHeight:(size.height - 20 - 48)];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    UINavigationController *nav = (UINavigationController *)searchController.searchResultsUpdater;
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
        if (range.length != NSNotFound)
        {
            [_resultArray addObject:model];
        }
    }
    return _resultArray;
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self resultArrayWithSearchText:searchText];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    if (!_topBarView)
    {
        _topBarView = [[TopBarView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 40)];
        _topBarView.backgroundColor = [UIColor whiteColor];
    }
    return _topBarView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
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
    if (scrollView.contentOffset.y - _lastOffsetY > 40)
    {
        [UIView animateWithDuration:0.4 animations:^{
            [_tableView setTop:20];
            [_searchBar setTop:-40];
        }];
    }
    else if (_lastOffsetY - scrollView.contentOffset.y > 40)
    {
        [UIView animateWithDuration:0.4 animations:^{
            [_tableView setTop:60];
            [_searchBar setTop:20];
        }];
    }
    if (scrollView.contentOffset.y ==0 )
    {
        [UIView animateWithDuration:0.4 animations:^{
            [_tableView setTop:60];
            [_searchBar setTop:20];
        }];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _lastOffsetY = scrollView.contentOffset.y;
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
