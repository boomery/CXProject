//
//  MyProjectViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/1.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "MyProjectViewController.h"
#import "Project.h"
#import "MyProjectCell.h"
#import "M_ProjectViewController.h"
@interface MyProjectViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, DZNEmptyDataSetSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sourceArray;
@property (nonatomic, strong) NSMutableArray *projectArray;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *maskButton;
@property (nonatomic, strong) NSMutableArray *searchResultArray;
@end

@implementation MyProjectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initViews];
    [self.tableView reloadData];
}

static NSString *myProjectCellIdentifier = @"MyProjectCell";
- (void)initViews
{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    self.navigationController.navigationBar.shadowImage = nil;
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0, 0, 15, 15);
    [searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"M_search"] forState:UIControlStateNormal];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = item;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.emptyDataSetSource = self;
    self.tableView = tableView;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyProjectCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:myProjectCellIdentifier];

    UIButton *topButton = [[UIButton alloc] initForAutoLayout];
    [self.view addSubview:topButton];
    [topButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-20];
    [topButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-100];
    [topButton autoSetDimensionsToSize:CGSizeMake(50, 50)];
    
    [topButton addTarget:self action:@selector(backToTop) forControlEvents:UIControlEventTouchUpInside];
    [topButton setBackgroundImage:[UIImage imageNamed:@"M_top"] forState:UIControlStateNormal];
}

- (void)initData
{
    _projectArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 20; i++)
    {
        Project *p = [[Project alloc] init];
        p.name = [NSString stringWithFormat:@"项目：%d",i];
        [_projectArray addObject:p];
    }
    _sourceArray = _projectArray;
}

- (void)backToTop
{
    if (_projectArray.count > 0)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark - 项目搜索
- (void)searchButtonClick
{
    if (!_searchBar)
    {
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        searchBar.delegate = self;
        _searchBar = searchBar;
    }
    self.navigationItem.titleView = _searchBar;
    [_searchBar becomeFirstResponder];
}

- (void)cancelSearch
{
    [_searchBar resignFirstResponder];
    [_maskButton removeFromSuperview];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (!_maskButton)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, self.view.width, self.view.height);
        button.backgroundColor = [UIColor blackColor];
        button.alpha = 0.3;
        [button addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
        _maskButton = button;
    }
    [self.view addSubview:_maskButton];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
    _searchResultArray = [[NSMutableArray alloc] init];
    for (Project *p in _projectArray)
    {
        if ([p.name containsString:searchBar.text])
        {
            [_searchResultArray addObject:p];
        }
    }
    _sourceArray = _searchResultArray;
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0)
    {
        _sourceArray = _projectArray;
        [self.tableView reloadData];
    }
    else
    {
        _searchResultArray = [[NSMutableArray alloc] init];
        for (Project *p in _projectArray)
        {
            if ([p.name containsString:searchBar.text])
            {
                [_searchResultArray addObject:p];
            }
        }
        _sourceArray = _searchResultArray;
        [self.tableView reloadData];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [_maskButton removeFromSuperview];
    self.navigationItem.titleView = nil;
    self.title = @"我的项目";
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:myProjectCellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    Project *project = _sourceArray[indexPath.section];
    cell.project = project;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    M_ProjectViewController *projectVC = [[M_ProjectViewController alloc] init];
    Project *project =  _sourceArray[indexPath.section];
    projectVC.project = project;
    projectVC.title =  project.name;
    [self.navigationController pushViewController:projectVC animated:YES];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"没有符合条件的项目";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -150;
}

- (void)didReceiveMemoryWarning
{
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
