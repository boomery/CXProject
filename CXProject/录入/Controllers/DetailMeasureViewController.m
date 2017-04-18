//
//  DetailMeasureViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/10.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "DetailMeasureViewController.h"
#import "LabelCell.h"
#import "InputView.h"
#import "MeasureResult+Addtion.h"
@interface DetailMeasureViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>
{
    NSArray *_titleArray;
    __weak IBOutlet UITextField *_standardTextField;
    InputView *_inputView;
    
    //记录选中的行与点
    NSIndexPath *_indexPath;
    //一个分项的录入点数组
    NSArray *_resultsArray;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *measureArea;
@property (weak, nonatomic) IBOutlet UITextField *measurePoint;
@end

@implementation DetailMeasureViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MHKeyboard addRegisterTheViewNeedMHKeyboard:self.view];
}

static NSString *labelCellIdentifier = @"LabelCell";
static NSString *tableViewIdentifier = @"tableViewIdentifier";
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
    [self setUpViewsWithIndex:0];
    [self initData];
}

- (void)initData
{
    [self loadMeasureResults];
    [self tableViewSetViews];
    [self CollectionViewSetViews];
    _indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:_indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.collectionView selectItemAtIndexPath:_indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)initViews
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"LabelCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:labelCellIdentifier];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:tableViewIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.collectionView.layer.borderWidth = 0.3;
    self.collectionView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.tableView.layer.borderWidth = 0.3;
    self.tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _standardTextField.layer.borderWidth = 0.3;
    _standardTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    InputView *view = [[InputView alloc] initForAutoLayout];
    _inputView = view;
    [self.view addSubview:view];
    [view autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.tableView];
    [view autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_standardTextField];
    [view autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    
    __weak typeof(self) weakSelf = self;;
    _inputView.saveBlock = ^{
        [weakSelf saveHaveMeasurePlace:@""];
    };
    _inputView.showBlock = ^{
        [weakSelf loadMeasureResults];
        if ([weakSelf haveData])
        {
            [weakSelf showPlace];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"请先保存录入数据后再保存地点"];
        }
    };
}
- (MeasureResult *)nowResult
{
    if ([self haveData])
    {
        return _resultsArray[_indexPath.row];
    }
    return [[MeasureResult alloc] init];
}
#pragma mark - 为控件布局
- (void)setUpViewsWithIndex:(NSInteger)index
{
    if (_event.events.count > index)
    {
        Event *subEvent = _event.events[index];
        //有文字标准的情况
        if (subEvent.textStandard)
        {
            _standardTextField.text = subEvent.textStandard;
        }
        //数字标准
        else
        {
            NSNumberFormatter *fo = [[NSNumberFormatter alloc] init];
            fo.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *minNum = [NSNumber numberWithFloat:subEvent.min];
            NSNumber *maxNum = [NSNumber numberWithFloat:subEvent.max];
            
            NSString *min = [fo stringFromNumber:minNum];
            NSString *max = [fo stringFromNumber:maxNum];
            _standardTextField.text = [NSString stringWithFormat:@"{%@~%@}mm",min,max];
        }
        [_inputView setUpViewsWithMeasurePoint:subEvent.measurePoint haveDesign:subEvent.needDesgin designName:subEvent.designName];
    }
}

#pragma mark - 判断数据记录是否存在
- (BOOL)haveData
{
    return _resultsArray.count > _indexPath.row;
}

#pragma mark - 从数据库查询本地分项录入点记录
- (void)loadMeasureResults
{
    if (_event.events.count > 0)
    {
        Event *subEvent = _event.events[_indexPath.section];
        NSArray *results = [MeasureResult resultsForProjectID:[User editingProject].fileName itemName:_event.name subItemName:subEvent.name];
        _resultsArray = results;
    }
}
#pragma mark - 选择大项时执行操作
- (void)tableViewSetViews
{
    [self.collectionView reloadData];
    [self.collectionView selectItemAtIndexPath:_indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];

    if ([self haveData])
    {
        [self setValueWithResult:_resultsArray[_indexPath.row]];
    }
    else
    {
        _measureArea.text = @"";
        _measurePoint.text = @"";
        [_inputView setMeasureValues:@""];
        [_inputView setDesignValues:@""];
        [SVProgressHUD showInfoWithStatus:@"无数据记录"];
    }
}
#pragma mark - 选择分项时执行操作
- (void)CollectionViewSetViews
{
    if ([self haveData])
    {
        [self setValueWithResult:_resultsArray[_indexPath.row]];
    }
    else
    {
        [_inputView setMeasureValues:@""];
        [SVProgressHUD showInfoWithStatus:@"无数据记录"];
    }
}

- (void)setValueWithResult:(MeasureResult *)result
{
    _measureArea.text = result.measureArea;
    _measurePoint.text = result.measurePoint;
    [_inputView setMeasureValues:result.measureValues];
    [_inputView setDesignValues:result.designValues];
}

#pragma mark - 录入点保存到本地
- (void)saveHaveMeasurePlace:(NSString *)measurePlace
{
    Event *subEvent = _event.events[_indexPath.section];
    MeasureResult *result = [self nowResult];

    result.projectID = [User editingProject].fileName;
    result.itemName = _event.name;
    result.subItemName = subEvent.name;
    result.measurePoint = _measurePoint.text;
    
    result.measureValues = _inputView.measureValues;
    result.designValues = _inputView.designValues;
    result.measureResult = @"1";
    result.measurePlace = measurePlace;
    result.mesaureIndex = [NSString stringWithFormat:@"%ld",(long)_indexPath.row];
    if ([result.measureArea integerValue] > [_measureArea.text integerValue])
    {
        [self showAlert];
    }
    else
    {
        result.measureArea = _measureArea.text;
        [self saveMeasureResult:result];
    }
}

- (void)saveMeasureResult:(MeasureResult *)result
{
    [MeasureResult insertNewMeasureResult:result];
    [self loadMeasureResults];
    [self.collectionView reloadData];
}

#pragma mark - 点击地点显示弹框
- (void)showPlace
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"录入点位置" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        MeasureResult *res = _resultsArray[_indexPath.row];
        textField.text = res.measurePlace;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self saveHaveMeasurePlace:alert.textFields[0].text];
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 保存时检测区小于原有检测区提示
- (void)showAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"新的检测区数少于原有检测区，保存会丢失超出设置区数的录入数据" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self nowResult].measureArea = _measureArea.text;
        [self saveMeasureResult:[self nowResult]];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"刷新时有 %ld 个区",(long)[[self nowResult].measureArea integerValue]);
    return [[self nowResult].measureArea integerValue];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:labelCellIdentifier forIndexPath:indexPath];
    UIView *selectedBackgroundView = [[UIView alloc] init];
    selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
    cell.selectedBackgroundView = selectedBackgroundView;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:_indexPath.section];
    [self loadMeasureResults];
    [self CollectionViewSetViews];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _event.events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewIdentifier forIndexPath:indexPath];
    cell.textLabel.font = LABEL_FONT;
    cell.textLabel.numberOfLines = 0;
    Event *event = _event.events[indexPath.row];
    cell.textLabel.text = event.name;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = [NSIndexPath indexPathForRow:_indexPath.row inSection:indexPath.row];
    [self setUpViewsWithIndex:_indexPath.section];
    [self loadMeasureResults];
    [self tableViewSetViews];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _standardTextField)
    {
        ALERT(textField.text);
        return NO;
    }
    return YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
