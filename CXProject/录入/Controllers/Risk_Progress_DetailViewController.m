//
//  Risk_Progress_DetailViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/7.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "Risk_Progress_DetailViewController.h"
#import "UIViewController+BackButtonHandler.h"
#import "Risk_Progress_ItemViewController.h"
@interface Risk_Progress_DetailViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_titleArray;
    BOOL _haveChanged;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation Risk_Progress_DetailViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initViews];
}
- (void)initData
{
    _titleArray = @[@"检查大项：", @"检查子项：", @"责任单位：", @"整改时间：", @"拍摄时间：", @"拍摄地点："];
}

- (void)initViews
{
    self.title = @"照片详情";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(savePhoto)];
    self.navigationItem.rightBarButtonItem = item;
    
    self.view.backgroundColor = [UIColor blackColor];
    UIView *headerView = [[UIView alloc] init];;
    headerView.frame = CGRectMake(0, 0, self.view.width, self.view.width);
    
    UIImageView *imageView = [[UIImageView alloc] initForAutoLayout];
    [headerView addSubview:imageView];
    [imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    imageView.backgroundColor = LINE_COLOR;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = self.photo.image;
    
    UIView *lineView = [[UIView alloc] initForAutoLayout];
    [headerView addSubview:lineView];
    [lineView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:imageView withOffset:7.5];
    [lineView autoSetDimensionsToSize:CGSizeMake(headerView.width, 0.5)];
    [lineView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    lineView.backgroundColor = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.00];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
    self.tableView.tableHeaderView = headerView;
}

- (BOOL)navigationShouldPopOnBackButton
{
    if (_haveChanged)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"编辑的信息尚未保存，确定退出吗?" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    return YES;
}

- (void)savePhoto
{
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"RESULT_CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    cell.textLabel.text = _titleArray[indexPath.section];
    switch (indexPath.section)
    {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            cell.detailTextLabel.text = @"施工单位";
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.detailTextLabel.text = self.photo.save_time;
        }
            break;
        case 5:
        {
            
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section)
    {
        case 0:
        {
            Risk_Progress_ItemViewController *riskVC = [[Risk_Progress_ItemViewController alloc] init];
            NSArray *itemArray = [DataProvider riskProgressItems];
            for (Event *event in itemArray)
            {
                if ([event.name isEqualToString:self.photo.kind])
                {
                    riskVC.event = event;
                }
            }
            [self.navigationController pushViewController:riskVC animated:YES];
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
         
        }
            break;
        case 5:
        {
            
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
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
