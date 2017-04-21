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
#import "BridgeUtil.h"
@interface DetailMeasureViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>
{
    NSArray *_titleArray;
    __weak IBOutlet UITextField *_standardTextField;
    InputView *_inputView;
    
    //记录选中的行与点
    NSIndexPath *_indexPath;
    //一个分项的录入点数组
    NSDictionary *_resultsDict;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;
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
    [self setViews];
    _indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:_indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.collectionView selectItemAtIndexPath:_indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)initViews
{
    if (IS_IPHONE_5)
    {
        _viewHeightConstraint.constant = 30;
    }
    else
    {
        _viewHeightConstraint.constant = 40;
    }
    
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
        [weakSelf saveHaveMeasurePlace:nil];
    };
    _inputView.showBlock = ^{
        if ([weakSelf exsistMeasureResultForIndexPath:_indexPath])
        {
            [weakSelf showPlace];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"请先保存录入数据后再输入地点"];
        }
    };
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

#pragma mark - 从数据库查询本地分项录入点记录
- (void)loadMeasureResults
{
    if (_event.events.count > 0)
    {
        Event *subEvent = _event.events[_indexPath.section];
        NSMutableDictionary *resultsDict = [MeasureResult resultsForProjectID:[User editingProject].fileName itemName:_event.name subItemName:subEvent.name];
        _resultsDict = resultsDict;
        [self.collectionView reloadData];
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

#pragma mark - 录入点保存到本地
- (void)saveHaveMeasurePlace:(NSString *)measurePlace
{
    if (_measureArea.text.length == 0 || _measurePoint.text.length == 0 || ![_inputView haveSetValue])
    {
        [SVProgressHUD showErrorWithStatus:@"请填写正确完整的数据"];
        return;
    }
    Event *subEvent = _event.events[_indexPath.section];
    MeasureResult *result = [self exsistMeasureResultForIndexPath:_indexPath];
    if (!result)
    {
        result = [[MeasureResult alloc] init];
    }
    result.projectID = [User editingProject].fileName;
    result.itemName = _event.name;
    result.subItemName = subEvent.name;
    result.measureArea = _measureArea.text;
    result.measurePoint = _measurePoint.text;
    result.measureValues = _inputView.measureValues;
    if (![_inputView.designValues isEqualToString:result.designValues])
    {
        NSArray *a = [_resultsDict allValues];
        for (MeasureResult *res in a)
        {
             NSString *countResult = [BridgeUtil resultForMeasureValues:res.measureValues designValues:_inputView.designValues event:subEvent];
            NSLog(@"测量值：%@，设计值：%@，原始结果：%@，重新计算结果：%@",res.measureValues,res.designValues,res.measureResult,countResult);
            res.measureResult = countResult;
            [MeasureResult insertNewMeasureResult:res];
        }
    }
    result.designValues = _inputView.designValues;
    //根据算法得出结果
    NSString *countResult = [BridgeUtil resultForMeasureValues:result.measureValues designValues:result.designValues event:subEvent];
    result.measureResult = countResult;
    if (measurePlace)
    {
        result.measurePlace = measurePlace;
    }
    if ([self isSpecial])
    {
        result.mesaureIndex = [NSString stringWithFormat:@"%ld",_indexPath.row/5];
    }
    else
    {
        result.mesaureIndex = [NSString stringWithFormat:@"%ld",_indexPath.row];
    }
    //插入数据库
    [MeasureResult insertNewMeasureResult:result];
    
    [_resultsDict setValue:result forKey:[NSString stringWithFormat:@"%ld",_indexPath.row]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_event.events.count > 0)
        {
            NSLog(@"保存完成后延迟0.5秒重新读取");
            Event *subEvent = _event.events[_indexPath.section];
            NSMutableDictionary *resultsDict = [MeasureResult resultsForProjectID:[User editingProject].fileName itemName:_event.name subItemName:subEvent.name];
            _resultsDict = resultsDict;
            [self.collectionView reloadData];
            [self.collectionView selectItemAtIndexPath:_indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    });
}
#pragma mark - 是否是算法三的数据
- (BOOL)isSpecial
{
    Event *subEvent = _event.events[_indexPath.section];
    if ([subEvent.method isEqualToString:@"3"])
        return YES;
    else
        return NO;
}


#pragma mark - 判断数据记录是否存在
- (MeasureResult *)exsistMeasureResultForIndexPath:(NSIndexPath *)indexPath
{
    if ([self isSpecial])
    {
        return _resultsDict[[NSString stringWithFormat:@"%ld",(long)indexPath.row/5]];
    }
    return _resultsDict[[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
}

#pragma mark - 选择大项分项时执行记录是否存在的判断 若存在则赋值
- (void)setViews
{
    [self clearMeasureValues];
    MeasureResult *res = [self exsistMeasureResultForIndexPath:_indexPath];
    if (res)
    {
        [self setValueWithResult:res];
    }
    else
    {
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

#pragma mark - 清空录入框
- (void)clearMeasureValues
{
    [_inputView setMeasureValues:@""];
}
- (void)clearMeasureAreaAndPoint
{
    _measureArea.text = @"";
    _measurePoint.text = @"";
}

#pragma mark - 点击地点显示弹框
- (void)showPlace
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"录入点位置" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        MeasureResult *res = _resultsDict[[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
        textField.text = res.measurePlace;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self saveHaveMeasurePlace:alert.textFields[0].text];
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 50;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:labelCellIdentifier forIndexPath:indexPath];
    UIView *selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView = selectedBackgroundView;
    selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
    cell.backgroundColor = [UIColor whiteColor];
    
    MeasureResult *res = [self exsistMeasureResultForIndexPath:indexPath];
    if (res)
    {
        NSArray *results = [res.measureResult componentsSeparatedByString:@";"];
        if (results.count > 1)
        {
            cell.label.text = results[indexPath.row%5];
        }
        else
        {
            cell.label.text = res.measureResult;
        }
        
        if ([cell.label.text isEqualToString:@"1"])
        {
            selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.84 green:0.35 blue:0.29 alpha:1.00];
            cell.backgroundColor = [UIColor colorWithRed:0.84 green:0.35 blue:0.29 alpha:1.00];
        }
    }
  else
  {
      cell.label.text = @"-";
  }
    return cell;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    _indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:_indexPath.section];
    [self setViews];
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
    [self.view endEditing:YES];
    _indexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
    [self setUpViewsWithIndex:_indexPath.section];
    [self loadMeasureResults];
    [self clearMeasureAreaAndPoint];
    [self setViews];
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
