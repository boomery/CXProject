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
    NSDictionary *_titleDict;
    NSDictionary *_imageNameDict;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MineViewController
- (void)viewDidAppear:(BOOL)animated
{
    //导航栏变为透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    //让黑线消失的方法
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([User isOurStaff])
    {
        _imageNameDict = @{@"0":@[@"my_project", @"attence", @"key_dict"], @"1":@[@"feedback", @"version", @"contact"]};
        _titleDict = @{@"0":@[ @"我的项目", @"现场考勤", @"关键词字典"], @"1":@[@"意见反馈", @"关于平大", @"联系我们"]};
    }
    else
    {
        _imageNameDict = @{@"0":@[@"my_project", @"feedback", @"version", @"contact"]};
        _titleDict = @{@"0":@[ @"我的项目"], @"1":@[@"意见反馈", @"关于平大", @"联系我们"]};
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    UIImageView *headerView = [[UIImageView alloc] init];
    headerView.image = [UIImage imageNamed:@"pd"];
    headerView.frame = CGRectMake(0, 0, self.view.width, self.view.width/750.0 * 358);
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - 49) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
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
    return [_titleDict allKeys].count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *titileArray = [_titleDict valueForKey:[NSString stringWithFormat:@"%ld",section]];
    return titileArray.count;
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

    NSArray *titileArray = [_titleDict valueForKey:[NSString stringWithFormat:@"%ld",indexPath.section]];

    cell.textLabel.text = titileArray[indexPath.row];
    
    NSArray *imageNameArray = [_imageNameDict valueForKey:[NSString stringWithFormat:@"%ld",indexPath.section]];

    if (imageNameArray.count > indexPath.row)
    {
        cell.imageView.image = [UIImage imageNamed:imageNameArray[indexPath.row]];
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
    
    NSArray *titileArray = [_titleDict valueForKey:[NSString stringWithFormat:@"%ld",indexPath.section]];

    if ([titileArray[indexPath.row] isEqualToString:@"意见反馈"])
    {
        FeedbackViewController *vc = [[FeedbackViewController alloc] init];
        vc.title = titileArray[indexPath.row];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([titileArray[indexPath.row] isEqualToString:@"联系我们"])
    {
        ContactViewController *vc = [[ContactViewController alloc] init];
        vc.title = titileArray[indexPath.row];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([titileArray[indexPath.row] isEqualToString:@"关于平大"])
    {
        VersionViewController *vc = [[VersionViewController alloc] init];
        vc.title = titileArray[indexPath.row];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([titileArray[indexPath.row] isEqualToString:@"关键词字典"])
    {
        NSArray *hotSeaches = @[@"关键词1", @"关键词12", @"关键词13", @"关键词41", @"关键词12", @"关键词41", @"关键词15", @"关键词31", @"关键词122", ];
        PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"输入关键词" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
            // Call this Block when completion search automatically
            // Such as: Push to a view controller
            UIViewController *vc = [[BaseViewController alloc] init];
            [searchViewController.navigationController pushViewController:vc animated:YES];
        }];
        searchViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:searchViewController animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        UIView *view = [[UIView alloc] init];
        UIButton *logoutButton = [[UIButton alloc] initForAutoLayout];
        [view addSubview:logoutButton];
        logoutButton.backgroundColor = [UIColor colorWithRed:0.64 green:0.64 blue:0.64 alpha:1.00];
        logoutButton.layer.cornerRadius = 5;
        logoutButton.clipsToBounds = YES;
        [logoutButton autoCenterInSuperview];
        [logoutButton autoSetDimensionsToSize:CGSizeMake(225, 44)];
        [logoutButton setTitle:@"退出" forState:UIControlStateNormal];
        [logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 88;
    }
    return 10;
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
