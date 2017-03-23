//
//  CountViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/3/22.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "CountViewController.h"
#import "PureLayout.h"
#import "CountCell.h"

#define BEGIN_Y 20

@interface CountViewController ()<UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate, UITableViewDataSource>
{
    UISearchBar *_searchBar;
    UIView *_headerView;
    UITableView *_tableView;
}
@end

@implementation CountViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (BOOL)shouldAutorotate
{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeLeft;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, BEGIN_Y, DEF_SCREEN_WIDTH, 40)];
    [self.view addSubview:searchBar];
    searchBar.placeholder = @"请输入您要查找的项目";
    searchBar.delegate = self;
    _searchBar = searchBar;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT-(BEGIN_Y+48)) style:UITableViewStylePlain];
    [self.view insertSubview:tableView belowSubview:searchBar];
    _tableView = tableView;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CountCell";
    CountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[CountCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!_headerView)
    {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 40)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
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
    
    -scrollView.contentOffset.y >= 20 ? [_searchBar setTop:20] : [_searchBar setTop:-scrollView.contentOffset.y];
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
