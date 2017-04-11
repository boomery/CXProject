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
    self.title = @"实测实量";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(upload)];
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
//    _titleArray = @[@"钢筋工程", @"模板工程", @"混凝土结构工程", @"砌筑工程", @"抹灰工程", @"涂饰工程", @"墙面饰面砖", @"地面饰面砖", @"木地板", @"门窗工程", @"防水工程", @"设备安装工程"];
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
