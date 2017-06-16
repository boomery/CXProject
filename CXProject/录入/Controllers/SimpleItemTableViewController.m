//
//  SimpleItemTableViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/14.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "SimpleItemTableViewController.h"

@interface SimpleItemTableViewController ()

@end

@implementation SimpleItemTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style])
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
        cell.textLabel.font = LABEL_FONT;
        cell.textLabel.numberOfLines = 0;
    }
    cell.textLabel.text = _itemArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.saveBlock(_itemArray[indexPath.row]);
    [self.navigationController popViewControllerAnimated:YES];
}
@end
