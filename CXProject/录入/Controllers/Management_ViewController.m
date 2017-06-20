//
//  Management_ViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/14.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "Management_ViewController.h"
#import "ManagementCell.h"
#import "ImageViewCell.h"
#import "NSString+isValid.h"
#import "Photo+Addtion.h"
#import "Risk_Progress_DetailViewController.h"
@interface Management_ViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *photosArray;
@end

@implementation Management_ViewController

static NSString *managementCellIdentifier = @"ManagementCell";
static NSString *imageViewCellIdentifier = @"ImageViewCell";
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
    [self initData];
}

- (void)initViews
{
    [MHKeyboard addRegisterTheViewNeedMHKeyboard:self.view];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT-64 - 54) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ManagementCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:managementCellIdentifier];
    
    [self createFooterView];

}

- (void)createFooterView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 130)];
    self.tableView.tableFooterView = view;
    
    UIView *lineView = [[UIView alloc] initForAutoLayout];
    [view addSubview:lineView];
    [lineView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:view];
    [lineView autoSetDimensionsToSize:CGSizeMake(view.width, 0.5)];
    [lineView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    lineView.backgroundColor = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.00];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 80) collectionViewLayout:layout];
    [view addSubview:collectionView];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.clipsToBounds = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerClass:[ImageViewCell class] forCellWithReuseIdentifier:imageViewCellIdentifier];
    self.collectionView = collectionView;
    
    UILabel *label = [[UILabel alloc] initForAutoLayout];
    [view addSubview:label];
    [label autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:collectionView];
    [label autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [label autoSetDimensionsToSize:CGSizeMake(100, 40)];
    label.backgroundColor = [UIColor colorWithRed:0.23 green:0.56 blue:0.96 alpha:1.00];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.text = @"保存";
}

- (void)initData
{
    [Photo photosForProjectID:[User editingProject].fileName kind:@"管理行为" item:_event.name completionBlock:^(NSMutableArray *resultArray) {
        _photosArray = resultArray;
        [self.collectionView reloadData];
    }];
}

- (void)upload
{
    [SVProgressHUD showSuccessWithStatus:@"上传完成"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _sourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ManagementCell *cell = [tableView dequeueReusableCellWithIdentifier:managementCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.standardButton.tag = indexPath.row;
    cell.scoreTextField.tag = indexPath.row;
    cell.scoreTextField.delegate = self;
    
    Event *event = _sourceArray[indexPath.row];
    cell.nameLabel.text = event.name;
    cell.scoreTextField.text = [Photo managementScoreForProjectID:[User editingProject].fileName event:_event subEvent:event];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event *event = _sourceArray[indexPath.row];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    CGSize size = [event.name boundingRectWithSize:CGSizeMake(DEF_SCREEN_WIDTH-160, MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size.height + 40;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _photosArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageViewCellIdentifier forIndexPath:indexPath];
   Photo *photo = _photosArray[indexPath.row];
    cell.photo = photo;
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Risk_Progress_DetailViewController *detailVC = [[Risk_Progress_DetailViewController alloc] init];
    Photo *photo = _photosArray[indexPath.row];
    detailVC.photoArray = self.photosArray;
    photo.tag = indexPath.row;
    detailVC.photo = photo;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout
//定义每个Cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 60);
}

//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);//分别为上、左、下、右
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.inputAccessoryView = [self toolbar];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

//控制检测区与检测点的录入字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length > 0 && ![string isValidInt])
    {
        [SVProgressHUD showInfoWithStatus:@"请输入正整数"];
        return NO;
    }
    Event *event = _sourceArray[textField.tag];
    [Photo saveManagementScore:[textField.text stringByAppendingString:string] projectID:[User editingProject].fileName event:_event subEvent:event];
    return YES;
}

- (UIToolbar *)toolbar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 50)];
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(textFieldShouldReturn:)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    NSArray *itemArrat = [[NSArray alloc] initWithObjects:spaceItem, spaceItem, spaceItem, nextItem, nil];
    toolbar.items = itemArrat;
    return toolbar;
}
@end
