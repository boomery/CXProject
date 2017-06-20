//
//  UploadPhotoTableViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/20.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "UploadPhotoTableViewController.h"
#import "Photo+Addtion.h"
#import "UploadCell.h"
#import "DetailMeasureViewController.h"
#import "SelectionView.h"
@interface UploadPhotoTableViewController () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, SelectionViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *photosArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@end

@implementation UploadPhotoTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.emptyDataSetSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"UploadCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UploadCell.h"];
    [self initData];
}

- (void)initData
{
    _selectedArray = [[NSMutableArray alloc] init];
    __weak typeof(self) weakSelf = self;
    self.selectBlock = ^(BOOL select) {
        weakSelf.isMultiSelect = select;
        if (!weakSelf.isMultiSelect)
        {
            //点击多选
            [SelectionView showInView:weakSelf.view delegate:weakSelf];
            weakSelf.bottomConstraint.constant = 60;
            [weakSelf.tableView reloadData];
            
        }
        else
        {
            //点击取消
            [SelectionView dismiss];
            weakSelf.bottomConstraint.constant = 0;
            [weakSelf.selectedArray removeAllObjects];
            [weakSelf.tableView reloadData];
        }
        _isMultiSelect = !_isMultiSelect;
    };
   
    [Photo photosForProjectID:[User editingProject].fileName hasUpload:self.hasUpload completionBlock:^(NSMutableArray *resultArray) {
        _photosArray = resultArray;
        [self.tableView reloadData];
    }];
}
#pragma mark - SelectionViewDelegate
- (void)didClickUpload
{
    
}
- (void)didClickSelectAll
{
    _selectedArray = [NSMutableArray arrayWithArray:_photosArray];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _photosArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UploadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UploadCell.h" forIndexPath:indexPath];
    cell.selectButton.hidden = YES;

    Photo *photo = _photosArray[indexPath.row];
    cell.photo = photo;
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
        if ([_selectedArray containsObject:photo])
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
    Photo *photo = _photosArray[indexPath.row];
    if (!_isMultiSelect)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        DetailMeasureViewController *detail = [[DetailMeasureViewController alloc] init];
//        detail.event = event;
//        detail.title = event.name;
//        [self.navigationController pushViewController:detail animated:YES];
    }
    else
    {
        if ([_selectedArray containsObject:photo])
        {
            [_selectedArray removeObject:photo];
        }
        else
        {
            [_selectedArray addObject:photo];
        }
        [self.tableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    if (self.hasUpload)
    {
        text = @"没有上传记录";
    }
    else
    {
        text = @"所有照片都上传啦";
    }
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"M_smile"];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -100;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
