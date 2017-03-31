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
#define TOPBAR_HEIGHT 44.0
#define SEARCHBAR_HEIGTH TOPBAR_HEIGHT
@interface CountViewController ()<UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate,UITableViewDelegate, UITableViewDataSource, TopBarViewDelegate>
{
    //界面相关
    UISearchBar *_searchBar;
    UISearchController *_searchController;
    TopBarView *_topBarView;
    //临时数据源
    NSMutableArray *_tempArray;
    NSMutableArray *_resultArray;
    
    CGFloat _navHeight;
}
@property (nonatomic, assign) BOOL isLandscape;
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

#pragma mark - 自动横屏布局
- (void)viewWillLayoutSubviews
{
    [_searchBar setWidth:self.view.width];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationMaskLandscape;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    self.isLandscape = !self.isLandscape;
    if (self.isLandscape)
    {
        self.tabBarController.tabBar.hidden = YES;
    }
    else
    {
        self.tabBarController.tabBar.hidden = NO;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark - TopBarViewDelegate
- (void)topBarViewDidClickedWithIndex:(NSInteger)index text:(NSString *)text topBarView:(TopBarView *)topBarView
{
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)topBarViewDidClickedChangeButton
{
    [self interfaceOrientation:(!self.isLandscape ? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait)];
}
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
- (void)topBarViewDidClickedSiftButton
{
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    return TOPBAR_HEIGHT;
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
            _topBarView = [[TopBarView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, TOPBAR_HEIGHT)];
            _topBarView.offSet = SEARCHBAR_HEIGTH;
            _topBarView.delegate = self;
            _topBarView.titleArray = @[@"综合排序",@"横竖屏切换",@"筛选:"];
        }
        return _topBarView;
    }
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
    _navHeight = self.navigationController.navigationBar.height+20;
#warning 由于_tableView加在了VC的TableView上，所以会随着contentoffset.y的偏移 发生位移 所以需要根据位移量重新计算坐标
    if (scrollView.contentOffset.y>-20)
    {
        [_topBarView.tableView setTop:(scrollView.contentOffset.y + _navHeight)+ _topBarView.offSet];
    }
}
//搜索框要么显示要么隐藏，不然会出现显示错位
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y < -_navHeight + 44/2)
    {
        _topBarView.offSet = SEARCHBAR_HEIGTH;
        [UIView animateWithDuration:0.2 animations:^{
            scrollView.contentOffset = CGPointMake(0, -_navHeight);
        }];
    }
    else if (scrollView.contentOffset.y < -_navHeight + 44)
    {
        [UIView animateWithDuration:0.2 animations:^{
            scrollView.contentOffset = CGPointMake(0, -_navHeight + 44);
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
