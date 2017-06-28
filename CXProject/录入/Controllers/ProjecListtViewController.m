//
//  ProjecListtViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/1.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "ProjecListtViewController.h"
#import "NewProjectViewController.h"
#import "ProjectViewController.h"
#import "Project.h"
#import "ProjectCell.h"
@interface ProjecListtViewController ()
{
    NSMutableArray *_projectArray;
}
@end

@implementation ProjecListtViewController

static NSString *newProjectCell = @"NewProjectCell";
static NSString *projectCell = @"ProjectCell";

- (void)viewWillAppear:(BOOL)animated
{
    _projectArray = [User projectList];;
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.93 alpha:1.00];

    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photoButton.frame = CGRectMake(0, 0, 17, 17);
    [photoButton addTarget:self action:@selector(createNewProject) forControlEvents:UIControlEventTouchUpInside];
    [photoButton setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:photoButton];
    self.navigationItem.rightBarButtonItem = item;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ProjectCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:projectCell];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)createNewProject
{
    NewProjectViewController *newVC = [[NewProjectViewController alloc] init];
    newVC.title = @"新建项目";
    newVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _projectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:projectCell forIndexPath:indexPath];
    Project *model = _projectArray[indexPath.row];
    cell.project = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProjectViewController *projectVC = [[ProjectViewController alloc] init];
    projectVC.hidesBottomBarWhenPushed = YES;
    [User setEditingProject:_projectArray[indexPath.row]];
    projectVC.project = _projectArray[indexPath.row];
    [self.navigationController pushViewController:projectVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
