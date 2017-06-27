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
#import "Photo+Addtion.h"
#import "XLPhotoBrowser.h"
#import "FileManager.h"
#import "SimpleItemTableViewController.h"
@interface Risk_Progress_DetailViewController ()<UITableViewDataSource, UITableViewDelegate, XLPhotoBrowserDatasource, XLPhotoBrowserDelegate>
{
    NSArray *_titleArray;
    BOOL _haveChanged;
    UIImageView *_headImageView;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation Risk_Progress_DetailViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self initData];
    [self initViews];
}
- (void)initData
{
    _titleArray = @[@"检查大项：", @"检查子项：", @"责任单位：", @"整改截止时间：", @"拍摄时间：", @"拍摄地点："];
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
    imageView.userInteractionEnabled = YES;
    [headerView addSubview:imageView];
    [imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    imageView.backgroundColor = LINE_COLOR;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = self.photo.image;
    _headImageView = imageView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewImages)];
    tap.numberOfTapsRequired = 1;
    [imageView addGestureRecognizer:tap];
    
    UIButton *button = [[UIButton alloc] initForAutoLayout];
    [imageView addSubview:button];
    [button autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:imageView];
    [button autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:imageView];
    [button autoSetDimensionsToSize:CGSizeMake(40, 40 )];
    [button setBackgroundImage:[UIImage imageNamed:@"delete_photo"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(deletePhoto) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] initForAutoLayout];
    [headerView addSubview:lineView];
    [lineView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:imageView withOffset:7.5];
    [lineView autoSetDimensionsToSize:CGSizeMake(headerView.width, 0.5)];
    [lineView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    lineView.backgroundColor = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.00];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
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
    //直接编辑详细分类执行
    if (self.saveBlock)
    {
        self.saveBlock(_photo);
        [self.navigationController popViewControllerAnimated:YES];
    }
    //先保存后编辑详细分类执行
    else
    {
        [Photo insertNewPhoto:_photo];
    }
}

- (void)viewImages
{
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:_photo.tag imageCount:self.photoArray.count datasource:self delegate:self];
    browser.browserStyle = XLPhotoBrowserStyleIndexLabel; // 微博样式
}

- (void)deletePhoto
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定删除这张照片吗?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if ([FileManager deleteImageForPhotoFilePath:_photo.photoFilePath] && [Photo deletePhoto:_photo])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - XLPhotoBrowserDatasource
/**
 *  返回这个位置的占位图片 , 也可以是原图
 *  如果不实现此方法,会默认使用placeholderImage
 *
 *  @param browser 浏览器
 *  @param index   位置索引
 *
 *  @return 占位图片
 */
- (UIImage *)photoBrowser:(XLPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    Photo *p = self.photoArray[index];
    return p.image;
}

/**
 *  返回指定位置图片的UIImageView,用于做图片浏览器弹出放大和消失回缩动画等
 *  如果没有实现这个方法,没有回缩动画,如果传过来的view不正确,可能会影响回缩动画效果
 *
 *  @param browser 浏览器
 *  @param index   位置索引
 *
 *  @return 展示图片的容器视图,如UIImageView等
 */
- (UIView *)photoBrowser:(XLPhotoBrowser *)browser sourceImageViewForIndex:(NSInteger)index
{
    return _headImageView;
}

#pragma mark - XLPhotoBrowserDelegate
- (void)photoBrowser:(XLPhotoBrowser *)browser moveToImageIndex:(NSInteger)currentImageIndex
{
    _photo = _photoArray[currentImageIndex];
    _photo.tag = currentImageIndex;
    _headImageView.image = _photo.image;
    
    [self.tableView reloadData];
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
        cell.detailTextLabel.font = LABEL_FONT;
        cell.detailTextLabel.numberOfLines = 0;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _titleArray[indexPath.section];
    switch (indexPath.section)
    {
        case 0:
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@",_photo.item,_photo.subItem];
        }
            break;
        case 1:
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@",_photo.subItem2,_photo.subItem3];
        }
            break;
        case 2:
        {
            cell.detailTextLabel.text = _photo.responsibility;
        }
            break;
        case 3:
        {
            cell.detailTextLabel.text = _photo.repair_time;
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
            riskVC.itemArray = [[NSMutableArray alloc] init];
            __weak typeof(self) weakSelf = self;
            riskVC.saveBlock = ^(NSArray *itemArray) {
                for (int i = 0; i< itemArray.count; i++)
                {
                    Event *event = itemArray[i];
                    switch (i) {
                        case 0:
                            _photo.item = event.name;
                            _photo.subItem = @"";
                            _photo.subItem2 = @"";
                            _photo.subItem3 = @"";
                            break;
                        case 1:
                            _photo.subItem = event.name;
                            _photo.subEvent = event;
                            _photo.subItem2 = @"";
                            _photo.subItem3 = @"";
                            break;
                        case 2:
                            _photo.subItem2 = event.name;
                            _photo.subItem3 = @"";
                            break;
                        case 3:
                            _photo.subItem3 = event.name;
                            break;
                        default:
                            break;
                    }

                }
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:riskVC animated:YES];
        }
            break;
        case 1:
        {
            Risk_Progress_ItemViewController *riskVC = [[Risk_Progress_ItemViewController alloc] init];
            riskVC.event = _photo.subEvent;
            riskVC.itemArray = [[NSMutableArray alloc] init];
            __weak typeof(self) weakSelf = self;
            riskVC.saveBlock = ^(NSArray *itemArray) {
                for (int i = 0; i< itemArray.count; i++)
                {
                    Event *event = itemArray[i];
                    switch (i) {
                        case 0:
                            _photo.subItem2 = event.name;
                            _photo.subItem3 = @"";
                            break;
                        case 1:
                            _photo.subItem3 = event.name;
                            break;
                        default:
                            break;
                    }
                }
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:riskVC animated:YES];
        }
            break;
        case 2:
        {
            SimpleItemTableViewController *simpleVC = [[SimpleItemTableViewController alloc] init];
            simpleVC.itemArray = @[@"精装单位", @"机电单位", @"门窗单位", @"总包单位"];
            __weak typeof(self) weakSelf = self;
            simpleVC.saveBlock = ^(NSString *string) {
                _photo.responsibility = string;
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:simpleVC animated:YES];
        }
            break;
        case 3:
        {
            SimpleItemTableViewController *simpleVC = [[SimpleItemTableViewController alloc] init];
            simpleVC.itemArray = @[@"5日内", @"10日内", @"15日内", @"30日内"];
            __weak typeof(self) weakSelf = self;
            simpleVC.saveBlock = ^(NSString *string) {
                NSString *numStr = [string stringByReplacingOccurrencesOfString:@"日内" withString:@""];
                 _photo.repair_time = [self computeDateWithDays:[numStr integerValue]];
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:simpleVC animated:YES];
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

//计算天数后的新日期
- (NSString *)computeDateWithDays:(NSInteger)days
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *myDate = [NSDate date];
    NSDate *newDate = [myDate dateByAddingTimeInterval:60 * 60 * 24 * days];
    return [dateFormatter stringFromDate:newDate];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    if (indexPath.section == 0)
    {
        NSDictionary *attribute = @{NSFontAttributeName:LABEL_FONT};
        size = [[NSString stringWithFormat:@"%@-%@",_photo.item,_photo.subItem] boundingRectWithSize:CGSizeMake(DEF_SCREEN_WIDTH*0.7 , MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        return size.height + 30;
    }
    else if (indexPath.section == 1)
    {
        NSDictionary *attribute = @{NSFontAttributeName:LABEL_FONT};
        size = [_photo.subItem2 boundingRectWithSize:CGSizeMake(DEF_SCREEN_WIDTH*0.7 , MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        return size.height + 30;
    }
    return 44;
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
