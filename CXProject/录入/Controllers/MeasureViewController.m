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
#import "FileManager.h"
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
        [SelectionView showInView:self.view leftTitle:@"全选" rightTitle:@"上传" delegate:self];
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

    for (Event *event in _selectedArray)
    {
        NSInteger index = [_titleArray indexOfObject:event];
        
        for (Event *subEvent in event.events)
        {
            //查询分项所有点数
            NSMutableDictionary *resultsDict = [MeasureResult resultsForProjectID:[User editingProject].fileName itemName:event.name subItemName:subEvent.name];
            //每个大项查询完毕
            if (subEvent == [event.events lastObject])
            {
                [[NSUserDefaults standardUserDefaults] setObject:[FileManager currentTime] forKey:T_UPLOADTIME_KEY([User editingProject].fileName , event.name)];
                
                [self.tableView beginUpdates];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];

            }
        }
        if (event == [_selectedArray lastObject])
        {
            [_selectedArray removeAllObjects];
            [self select];
        }
       
    }
    [self.tableView reloadData];
}

- (void)didClickSelectAll
{
    _selectedArray = [NSMutableArray arrayWithArray:_titleArray];
    [self.tableView reloadData];
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
    Event *event = _titleArray[indexPath.row];
    cell.event = event;
    cell.isMultiSelect = _isMultiSelect;
    if ([_selectedArray containsObject:event])
    {
        cell.selectButton.selected = YES;
    }
    else
    {
        cell.selectButton.selected = NO;
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
