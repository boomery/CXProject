//
//  MineViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/3/22.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "MineViewController.h"

@interface MineViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_titleArray;
    NSArray *_imageNameArray;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    
    UIImageView *headerView = [[UIImageView alloc] init];
    headerView.image = [UIImage imageNamed:@"pd"];
    headerView.frame = CGRectMake(0, 0, self.view.width, self.view.height*0.25);
    
    UITableView *tableView = [[UITableView alloc] initForAutoLayout];
    [self.view addSubview:tableView];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView autoPinEdgesToSuperviewEdges];
    self.tableView = tableView;

    self.tableView.tableHeaderView = headerView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([User isOurStaff])
    {
        _imageNameArray = @[@"attence", @"my_project", @"feedback", @"contact", @"version", @"keyword"];
        _titleArray = @[@"现场考勤", @"我的项目", @"意见反馈", @"联系我们", @"版本信息", @"关键词字典"];
    }
    else
    {
        _imageNameArray = @[@"my_project", @"feedback", @"contact", @"version"];
        _titleArray = @[@"我的项目", @"意见反馈", @"联系我们", @"版本信息"];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 1;
    }
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 0)
    {
        cell.textLabel.text = _titleArray[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:_imageNameArray[indexPath.row]];
    }
    else
    {
        cell.textLabel.text = @"退出登录";
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1)
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
