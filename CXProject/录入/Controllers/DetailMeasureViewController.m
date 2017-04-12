//
//  DetailMeasureViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/10.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "DetailMeasureViewController.h"
#import "LabelCell.h"
@interface DetailMeasureViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITextViewDelegate>
{
    NSArray *_titleArray;
    __weak IBOutlet UITextView *_standardTextField;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger selectedRow;
@end

@implementation DetailMeasureViewController
static NSString *labelCellIdentifier = @"LabelCell";
static NSString *tableViewIdentifier = @"tableViewIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LabelCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:labelCellIdentifier];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:tableViewIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.collectionView.layer.borderWidth = 0.3;
    self.collectionView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.tableView.layer.borderWidth = 0.3;
    self.tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _standardTextField.layer.borderWidth = 0.3;
    _standardTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [self setUpViewsWithIndex:0];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MHKeyboard addRegisterTheViewNeedMHKeyboard:self.view];
}
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
            return;
        }
        NSNumberFormatter *fo = [[NSNumberFormatter alloc] init];
        fo.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *minNum = [NSNumber numberWithFloat:event.min];
        NSNumber *maxNum = [NSNumber numberWithFloat:event.max];
        
        NSString *min = [fo stringFromNumber:minNum];
        NSString *max = [fo stringFromNumber:maxNum];
        _standardTextField.text = [NSString stringWithFormat:@"{%@~%@}mm",min,max];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    ALERT(textView.text);
    return NO;
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
