//
//  MineViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/3/22.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "MineViewController.h"
#import "FeedbackViewController.h"
#import "ContactViewController.h"
#import "VersionViewController.h"
#import "PYSearchViewController.h"
@interface MineViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_titleArray;
    NSArray *_imageNameArray;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MineViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.999 green:0.03 blue:0.005 alpha:1.00];

    if ([User isOurStaff])
    {
        _imageNameArray = @[@"attence", @"my_project", @"feedback", @"contact", @"version", @"key_dict"];
        _titleArray = @[@"现场考勤", @"我的项目", @"意见反馈", @"联系我们", @"版本信息", @"关键词字典"];
    }
    else
    {
        _imageNameArray = @[@"my_project", @"feedback", @"contact", @"version"];
        _titleArray = @[@"我的项目", @"意见反馈", @"联系我们", @"版本信息"];
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    UIImageView *headerView = [[UIImageView alloc] init];
    headerView.image = [UIImage imageNamed:@"pd"];
    headerView.frame = CGRectMake(0, 0, self.view.width, self.view.height*0.25);
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - 49 - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
    self.tableView.tableHeaderView = headerView;
}

- (void)logout
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定要退出吗？" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [User logoutWithBlock:^(BOOL loginStatus) {
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [delegate.tab setSelectedIndex:0];
        }];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    cell.textLabel.text = _titleArray[indexPath.row];
    if (_imageNameArray.count > indexPath.row)
    {
        cell.imageView.image = [UIImage imageNamed:_imageNameArray[indexPath.row]];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_titleArray[indexPath.row] isEqualToString:@"意见反馈"])
    {
        FeedbackViewController *vc = [[FeedbackViewController alloc] init];
        vc.title = _titleArray[indexPath.row];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([_titleArray[indexPath.row] isEqualToString:@"联系我们"])
    {
        ContactViewController *vc = [[ContactViewController alloc] init];
        vc.title = _titleArray[indexPath.row];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([_titleArray[indexPath.row] isEqualToString:@"版本信息"])
    {
        VersionViewController *vc = [[VersionViewController alloc] init];
        vc.title = _titleArray[indexPath.row];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([_titleArray[indexPath.row] isEqualToString:@"关键词字典"])
    {
        NSArray *hotSeaches = @[@"关键词1", @"关键词12", @"关键词13", @"关键词41", @"关键词12", @"关键词41", @"关键词15", @"关键词31", @"关键词122", ];
        PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"输入关键词" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
            // Call this Block when completion search automatically
            // Such as: Push to a view controller
            UIViewController *vc = [[BaseViewController alloc] init];
            [searchViewController.navigationController pushViewController:vc animated:YES];
        }];
        [self.navigationController pushViewController:searchViewController animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    UIButton *logoutButton = [[UIButton alloc] initForAutoLayout];
    [view addSubview:logoutButton];
    logoutButton.backgroundColor = [UIColor colorWithRed:0.32 green:0.33 blue:0.33 alpha:1.00];
    logoutButton.layer.cornerRadius = 5;
    logoutButton.clipsToBounds = YES;
    [logoutButton autoCenterInSuperview];
    [logoutButton autoSetDimensionsToSize:CGSizeMake(225, 44)];
    [logoutButton setTitle:@"退出" forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 88;
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
