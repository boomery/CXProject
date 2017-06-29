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
#import "InputCell4.h"

#import "UIMyDatePicker.h"
@interface NewProjectViewController () <UITableViewDataSource, UITableViewDelegate, UIMyDatePickerDelegate, UITextFieldDelegate>
{
    UIMyDatePicker *_datePicker;
    //记录当前编辑的输入框
    UITextField *_activeTextField;
    //记录编辑前输入框的值
    NSString *_originalText;
    
    NSArray *_titleArray;
    Project *_project;
    //存放project类的属性名称 方便赋值
    NSArray *_propertiesArray;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation NewProjectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self initViews];
}
- (void)initData
{
    if (!_project)
    {
        _project = [[Project alloc] init];
    }
    _titleArray = @[@"地产名称", @"项目名称", @"项目区域", @"项目标段", @"监理单位", @"评估类型",@"评估轮次", @"评估日期", @"评估组长"];
    _propertiesArray = @[@"realPropertyName", @"name", @"district", @"site", @"supervisory",@"type", @"turn",  @"measure_date", @"captain"];
}

static NSString *inputCell = @"InputCell";
static NSString *inputCell2 = @"InputCell2";
static NSString *inputCell3 = @"InputCell3";
static NSString *inputCell4 = @"InputCell4";
- (void)initViews
{
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = item;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"InputCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:inputCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"InputCell2" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:inputCell2];
    [self.tableView registerNib:[UINib nibWithNibName:@"InputCell3" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:inputCell3];
    [self.tableView registerNib:[UINib nibWithNibName:@"InputCell4" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:inputCell4];

    [MHKeyboard addRegisterTheViewNeedMHKeyboard:self.view];
    
    _datePicker = [[UIMyDatePicker alloc] initWithDelegate:self];
    _datePicker.frame = CGRectMake(0, DEF_SCREEN_HEIGHT, DEF_SCREEN_WIDTH, 260);
}

#pragma mark - 保存到本地
- (void)save
{
    [self.view endEditing:YES];
    [User saveProject:_project];
}

#pragma mark - UIMyDatePickerDelegate
-(void)myDatePickerDidClickSure:(UIMyDatePicker *)picker
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [formatter stringFromDate:picker.datePicker.date];
    _activeTextField.text = str;
    [self.view endEditing:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return _titleArray.count;
            break;
        case 1:
            return _project.members.count;
            break;
        case 2:
            return _project.builders.count;
            break;
        case 3:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            InputCell *cell = [tableView dequeueReusableCellWithIdentifier:inputCell forIndexPath:indexPath];
            cell.textField.delegate = self;
            if (indexPath.row == 7)
            {
                cell.textField.inputView = _datePicker;
            }
            cell.nameLabel.text = _titleArray[indexPath.row];
            cell.textField.text = [_project valueForKey:_propertiesArray[indexPath.row]];
            return cell;
        }
            break;
        case 1:
        {
            InputCell4 *cell = [tableView dequeueReusableCellWithIdentifier:inputCell4 forIndexPath:indexPath];
            cell.memberTextField.delegate = self;
            [cell.addButton addTarget:self action:@selector(addMember:) forControlEvents:UIControlEventTouchUpInside];
            cell.memberTextField.text = _project.members[indexPath.row];
            return cell;
        }
            break;
        case 2:
        {
            InputCell2 *cell = [tableView dequeueReusableCellWithIdentifier:inputCell2 forIndexPath:indexPath];
            cell.contractNatureTextField.delegate = self;
            cell.unitName.delegate = self;
            cell.contractArea.delegate = self;
            [cell.addButton addTarget:self action:@selector(addCompany:) forControlEvents:UIControlEventTouchUpInside];
            NSDictionary *dict = _project.builders[indexPath.row];
            cell.contractNatureTextField.text = dict[@"承包性质"];
            cell.unitName.text = dict[@"单位名称"];
            cell.contractArea.text = dict[@"承包范围"];
            return cell;
        }
            break;
        case 3:
        {
            InputCell3 *cell = [tableView dequeueReusableCellWithIdentifier:inputCell3 forIndexPath:indexPath];
            cell.addressTextField.delegate = self;
            cell.chargemanTextField.delegate = self;
            cell.chargemanPhone.delegate = self;
            cell.areaTextField.delegate = self;
            cell.progressTextField.delegate = self;
            cell.end_dateTextField.delegate = self;
            cell.end_dateTextField.inputView = _datePicker;
            cell.addressTextField.text = _project.address;
            cell.chargemanTextField.text = _project.chargeman;
            cell.chargemanPhone.text = _project.chargemanPhone;
            cell.areaTextField.text = _project.area;
            cell.progressTextField.text = _project.progress;
            cell.end_dateTextField.text = _project.end_date;
            return cell;
        }
            break;
        default:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
            return cell;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
            return 44;
            break;
        case 1:
            return 44;
            break;
        case 2:
            return 160;
            break;
        case 3:
            return 280;
            break;
        default:
            return 0;
            break;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activeTextField = textField;
    _originalText = _activeTextField.text;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}

#pragma mark - 向对象赋值
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    UITableViewCell *cell = (UITableViewCell *)[[textField nextResponder] nextResponder];
    if (cell)
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        switch (indexPath.section)
        {
            case 0:
            {
                InputCell *c = (InputCell *)cell;
                [_project setValue:c.textField.text forKey:_propertiesArray[indexPath.row]];
            }
                break;
            case 1:
            {
                InputCell4 *c = (InputCell4 *)cell;
                [_project.members replaceObjectAtIndex:indexPath.row withObject:c.memberTextField.text];
            }
                break;
            case 2:
            {
                InputCell2 *c = (InputCell2 *)cell;
                NSMutableDictionary *dict = _project.builders[indexPath.row];
                NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] initWithDictionary:dict];
                [dict2 setValue:c.contractNatureTextField.text forKey:@"承包性质"];
                [dict2 setValue:c.unitName.text forKey:@"单位名称"];
                [dict2 setValue:c.contractArea.text forKey:@"承包范围"];
                [_project.builders replaceObjectAtIndex:indexPath.row withObject:dict2];
            }
                break;
            case 3:
            {
                InputCell3 *c = (InputCell3 *)cell;
                _project.address = c.addressTextField.text;
                _project.chargeman = c.chargemanTextField.text;
                _project.chargemanPhone = c.chargemanPhone.text;
                _project.area = c.areaTextField.text;
                _project.progress = c.progressTextField.text;
                _project.end_date = c.end_dateTextField.text;
            }
                break;
            default:
                break;
        }
    }
    _activeTextField = nil;
    return YES;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        if (_project.members.count == 1)
        {
            return NO;
        }
    }
    if (indexPath.section == 2)
    {
        if (_project.builders.count == 1)
        {
            return NO;
        }
    }
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 || indexPath.section == 2)
    {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (indexPath.section == 1)
        {
             [_project.members removeObjectAtIndex:indexPath.row];
        }
        if (indexPath.section == 2)
        {
             [_project.builders removeObjectAtIndex:indexPath.row];
        }
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}


#pragma mark - 添加施工单位
- (void)addCompany:(UIButton *)button
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [_project.builders addObject:dict];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_project.builders.count - 1 inSection:2]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

- (void)addMember:(UIButton *)button
{
    [_project.members addObject:@""];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_project.members.count-1 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
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
