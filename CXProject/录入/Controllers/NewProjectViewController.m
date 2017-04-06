//
//  NewProjectViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/6.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "NewProjectViewController.h"
#import "InputCell.h"
#import "MHKeyboard.h"
#import "UIMyDatePicker.h"
@interface NewProjectViewController () <UITableViewDataSource, UITableViewDelegate, UIMyDatePickerDelegate, UITextFieldDelegate>
{
    UIMyDatePicker *_datePicker;
    NSArray *_titleArray;
    UITextField *_activeTextField;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation NewProjectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"新建项目";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = item;
    
    _titleArray = @[@"项目名称", @"项目区域", @"项目标段", @"评估轮次", @"监理单位", @"评估日期", @"评估人员", @"施工单位", @"项目简介"];
    [self initViews];
}

static NSString *cellIdentifier = @"InputCell";
- (void)initViews
{
    UITableView *tableView = [[UITableView alloc] initForAutoLayout];
    [self.view addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView autoPinEdgesToSuperviewEdges];
    tableView.allowsSelection = NO;
    self.tableView = tableView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"InputCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
    
    [MHKeyboard addRegisterTheViewNeedMHKeyboard:self.view];
    
    _datePicker = [[UIMyDatePicker alloc] initWithDelegate:self];
    _datePicker.frame = CGRectMake(0, DEF_SCREEN_HEIGHT, DEF_SCREEN_WIDTH, 260);
}

#pragma mark - 保存到本地
- (void)save
{
    [SVProgressHUD showSuccessWithStatus:@"保存完成"];
}

#pragma mark - UIMyDatePickerDelegate
-(void)myDatePickerDidClickSure:(UIMyDatePicker *)picker
{
    [self.view endEditing:YES];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [formatter stringFromDate:picker.datePicker.date];
    _activeTextField.text = str;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InputCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.nameLabel.text = _titleArray[indexPath.row];
    cell.textField.delegate = self;
    if (indexPath.row == 5)
    {
        cell.textField.inputView = _datePicker;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 7:
            return 200;
            break;
            
        default:
            return 54;

            break;
    }
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activeTextField = textField;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
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
