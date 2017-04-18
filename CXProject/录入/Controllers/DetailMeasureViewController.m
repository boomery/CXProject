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
    _indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self setUpViewsWithIndex:0];
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
}

#pragma mark - 保存到本地
- (void)save
{
    Event *subEvent = _event.events[_indexPath.section];
    MeasureResult *result = [[MeasureResult alloc] init];
    result.projectID = [User editingProject].fileName;
    result.itemName = _event.name;
    result.subItemName = subEvent.name;
    result.measureArea = _measureArea.text;
    result.measurePoint = _measurePoint.text;
    result.measureValues = _inputView.measureValues;
    result.designValues = _inputView.designValues;
    result.measureResult = @"1";
    result.mesaureIndex = [NSString stringWithFormat:@"%ld",_indexPath.row];
    [MeasureResult insertNewMeasureResult:result];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 100;
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
}

- (void)setUpViewsWithIndex:(NSInteger)index
{
    if (_event.events.count > index)
    {
        Event *event = _event.events[index];
        
        if (event.textStandard)
        {
            _standardTextField.text = event.textStandard;
        }
        else
        {
            NSNumberFormatter *fo = [[NSNumberFormatter alloc] init];
            fo.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *minNum = [NSNumber numberWithFloat:event.min];
            NSNumber *maxNum = [NSNumber numberWithFloat:event.max];
            
            NSString *min = [fo stringFromNumber:minNum];
            NSString *max = [fo stringFromNumber:maxNum];
            _standardTextField.text = [NSString stringWithFormat:@"{%@~%@}mm",min,max];
        }
        
        if (!_inputView)
        {
            InputView *view = [[InputView alloc] initForAutoLayout];
            _inputView = view;
            [self.view addSubview:view];
            [view autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.tableView];
            [view autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
            [view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_standardTextField];
            [view autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
            __weak typeof(self) weakSelf = self;;
            _inputView.saveBlock = ^{
                [weakSelf save];
//                _indexPath = [NSIndexPath indexPathForRow:(_indexPath.row+1) inSection:_indexPath.section];
//                NSLog(@"")
            };
            _inputView.showBlock = ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"录入点位置" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.text = @"二楼阳台顶板";
                }];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                   
                }]];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            };
        }
        
        [_inputView setUpViewsWithMeasurePoint:event.measurePoint haveDesign:event.needDesgin designName:event.designName];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
