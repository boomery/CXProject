//
//  NewProjectViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/6.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "NewProjectViewController.h"
#import "InputCell.h"
#import "InputCell2.h"
#import "InputCell3.h"
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

static NSString *inputCell = @"InputCell";
static NSString *inputCell2 = @"InputCell2";
static NSString *inputCell3 = @"InputCell3";
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"InputCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:inputCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"InputCell2" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:inputCell2];
    [self.tableView registerNib:[UINib nibWithNibName:@"InputCell3" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:inputCell3];

    
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
    switch (indexPath.row)
    {
        case 7:
        {
            InputCell2 *cell = [tableView dequeueReusableCellWithIdentifier:inputCell2 forIndexPath:indexPath];
            return cell;
        }
            break;
        case 8:
        {
            InputCell3 *cell = [tableView dequeueReusableCellWithIdentifier:inputCell3 forIndexPath:indexPath];
            return cell;
        }
            break;
        default:
        {
            InputCell *cell = [tableView dequeueReusableCellWithIdentifier:inputCell forIndexPath:indexPath];
            cell.nameLabel.text = _titleArray[indexPath.row];
            cell.textField.delegate = self;
            if (indexPath.row == 5)
            {
                cell.textField.inputView = _datePicker;
            }
            return cell;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 7:
            return 160;
            break;
        case 8:
            return 240;
            break;
            
        default:
            return 44;

            break;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activeTextField = textField;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
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
