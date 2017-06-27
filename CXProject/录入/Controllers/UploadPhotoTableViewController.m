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
#import "FileManager.h"
#import "Risk_Progress_DetailViewController.h"
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
            if (weakSelf.hasUpload)
            {
                //点击多选
                [SelectionView showInView:weakSelf.view leftTitle:@"全选" rightTitle:@"删除" delegate:weakSelf];
            }
            else
            {
                //点击多选
                [SelectionView showInView:weakSelf.view leftTitle:@"全选" rightTitle:@"上传" delegate:weakSelf];
            }
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
    if (_selectedArray.count == 0)
    {
        [SVProgressHUD showInfoWithStatus:@"尚未选择项目"];
        return;
    }
    
    //删除已上传照片管理
    if (self.hasUpload)
    {
        for (Photo *photo in _selectedArray)
        {
            NSInteger index = [_photosArray indexOfObject:photo];

            [Photo deletePhoto:photo];
            [_photosArray removeObject:photo];
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
            [self.tableView endUpdates];
            
            if (photo == [_selectedArray lastObject])
            {
                [_selectedArray removeAllObjects];
            }
        }
        return;
    }
    //上传未上传的照片
    for (Photo *photo in _selectedArray)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (!photo.image)
            {
                UIImage *image = [UIImage imageWithContentsOfFile:photo.photoFilePath];
                photo.image = image;
            }
            [NetworkAPI uploadImage:photo.image projectID:photo.projectID name:photo.photoName savetime:photo.save_time place:photo.place kind:photo.kind item:photo.item subitem:photo.subItem subitem2:photo.subItem2 subitem3:photo.subItem3 responsibility:photo.responsibility repairtime:photo.repair_time showHUD:YES successBlock:^(id returnData) {
                
                NSInteger index = [_photosArray indexOfObject:photo];
                
                NSLog(@"%ld",index);
                [_photosArray removeObject:photo];
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
                [self.tableView endUpdates];
                
                //改变上传状态  更改数据库记录状态  置空imgae释放内存
                photo.uploadTime = [FileManager currentTime];
                photo.hasUpload = @"YES";
                [Photo insertNewPhoto:photo];
                photo.image = nil;
                
                //所有上传完成后隐藏底部的上传视图，更改底部约束，移除选中数组的对象
                if (photo == [_selectedArray lastObject])
                {
                    [SelectionView dismiss];
                    _bottomConstraint.constant = 0;
                    [_selectedArray removeAllObjects];
                    if (self.uploadBlock)
                    {
                        self.uploadBlock();
                    }
                }
            } failureBlock:^(NSError *error) {
                
            }];
        });
    }
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
    
    NSLog(@"%d ~~ %d ", self.hasUpload ,_isMultiSelect);
    
    //非多选
    if (!_isMultiSelect)
    {
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    //多选模式
    else
    {
//        cell.accessoryType = UITableViewCellAccessoryNone;
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
        if (!self.hasUpload)
        {
            Risk_Progress_DetailViewController *detailVC = [[Risk_Progress_DetailViewController alloc] init];
            detailVC.photoArray = _photosArray;
            photo.tag = indexPath.row;
            photo.tag = [detailVC.photoArray indexOfObject:photo];
            detailVC.photo = photo;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
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
