//
//  MeasureViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/10.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "MeasureViewController.h"
#import "DetailMeasureViewController.h"
@interface MeasureViewController ()
{
    NSArray *_titleArray;
}
@end

@implementation MeasureViewController

static NSString *cellIndentifier = @"UITableViewCell";
- (void)viewDidLoad
{
    [super viewDidLoad];    
    UIButton *uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadButton.frame = CGRectMake(0, 0, 40, 40);
    uploadButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [uploadButton addTarget:self action:@selector(upload) forControlEvents:UIControlEventTouchUpInside];
    [uploadButton setImage:[UIImage imageNamed:@"upload"] forState:UIControlStateNormal];
    [uploadButton setTitle:@"上传" forState:UIControlStateNormal];
    [uploadButton setTitleEdgeInsets:UIEdgeInsetsMake(25, -10, 0, -10)];
    [uploadButton setImageEdgeInsets:UIEdgeInsetsMake(5, 20, 15, -10)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:uploadButton];
    self.navigationItem.rightBarButtonItem = item;
    
    [self initData];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIndentifier];
}

- (void)upload
{
    [SVProgressHUD showSuccessWithStatus:@"上传完成"];
}

- (void)initData
{
    _titleArray = [DataProvider items];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    Event *event = _titleArray[indexPath.row];
    cell.textLabel.text = event.name;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailMeasureViewController *detail = [[DetailMeasureViewController alloc] init];
    Event *event = _titleArray[indexPath.row];
    detail.event = event;
    detail.title = event.name;
    [self.navigationController pushViewController:detail animated:YES];
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
