//
//  MeasureViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/10.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "MeasureViewController.h"
#import "DetailMeasureViewController.h"
#import "MeasureResult+Addtion.h"
#import "SelectionView.h"
#import "MeasureCell.h"
@interface MeasureViewController () <SelectionViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_titleArray;
    BOOL _isMultiSelect;
    NSMutableArray *_selectedArray;

    __weak IBOutlet NSLayoutConstraint *_bottomConstraint;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MeasureViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (Event *event in _titleArray)
    {
        [MeasureResult resultsForProjectID:[User editingProject].fileName itemName:event.name];
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(select)];
    self.navigationItem.rightBarButtonItem = item;
    [self.tableView registerNib:[UINib nibWithNibName:@"MeasureCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MeasureCell.h"];
    [self initData];
}

- (void)select
{
    if (!_isMultiSelect)
    {
        //点击多选
        [SelectionView showInView:self.view delegate:self];
        _bottomConstraint.constant = 60;
        [self.tableView reloadData];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(select)];
        self.navigationItem.rightBarButtonItem = item;
    }
    else
    {
        //点击取消
        [SelectionView dismiss];
        _bottomConstraint.constant = 0;
        [_selectedArray removeAllObjects];
        [self.tableView reloadData];
        
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(select)];
        self.navigationItem.rightBarButtonItem = item;
    }
    _isMultiSelect = !_isMultiSelect;
}

- (void)initData
{
    _selectedArray = [[NSMutableArray alloc] init];
    _titleArray = [DataProvider measureItems];
}

#pragma mark - SelectionViewDelegate
- (void)didClickUpload
{
    if (_selectedArray.count == 0)
    {
        [SVProgressHUD showInfoWithStatus:@"尚未选择项目"];
        return;
    }
    [SelectionView dismiss];
    _bottomConstraint.constant = 0;
    [_selectedArray removeAllObjects];
    [self.tableView reloadData];
    NSLog(@"上传");
}

- (void)didClickSelectAll
{
    _selectedArray = [NSMutableArray arrayWithArray:_titleArray];
    [self.tableView reloadData];
    NSLog(@"全选");
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeasureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeasureCell.h" forIndexPath:indexPath];
    cell.selectButton.hidden = YES;
    cell.uploadTime.text = @"无上传记录";
    Event *event = _titleArray[indexPath.row];
    cell.nameLabel.text = event.name;
    
    NSInteger results = [MeasureResult tNumOfResultsForProjectID:[User editingProject].fileName itemName:event.name];
    NSInteger qualified = [MeasureResult tNumOfQualifiedForProjectID:[User editingProject].fileName itemName:event.name];
    if (results == 0)
    {
        cell.qualifiedLabel.text = @"无录入点记录";
    }
    else
    {
        cell.qualifiedLabel.text = [NSString stringWithFormat:@"合格率:%.0f%%", (float)qualified/results*100];
    }
    
    //非多选
    if (!_isMultiSelect)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    //多选模式
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectButton.hidden = NO;
        if ([_selectedArray containsObject:event])
        {
            cell.selectButton.selected = YES;
        }
        else
        {
            cell.selectButton.selected = NO;
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event *event = _titleArray[indexPath.row];
    if (!_isMultiSelect)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        DetailMeasureViewController *detail = [[DetailMeasureViewController alloc] init];
        detail.event = event;
        detail.title = event.name;
        [self.navigationController pushViewController:detail animated:YES];
    }
    else
    {
        if ([_selectedArray containsObject:event])
        {
            [_selectedArray removeObject:event];
        }
        else
        {
            [_selectedArray addObject:event];
        }
        [self.tableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
