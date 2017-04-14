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
@interface DetailMeasureViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>
{
    NSArray *_titleArray;
    __weak IBOutlet UITextField *_standardTextField;
    InputView *_inputView;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger selectedRow;
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
    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
//    self.navigationItem.rightBarButtonItem = item;

    [self initViews];
    [self setUpViewsWithIndex:0];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
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
//- (void)save
//{
//    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
//}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 100;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:labelCellIdentifier forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    _selectedRow = indexPath.row;
    [self setUpViewsWithIndex:_selectedRow];
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
            _inputView.saveBlock = ^{
                [SVProgressHUD showSuccessWithStatus:@"保存完成，开始下一个"];
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
