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
#import "ConstructionCompany.h"
#import "Member.h"
@interface NewProjectViewController () <UITableViewDataSource, UITableViewDelegate, UIMyDatePickerDelegate, UITextFieldDelegate>
{
    UIMyDatePicker *_datePicker;
    //记录当前编辑的输入框
    UITextField *_activeTextField;
    //记录编辑前输入框的值
    NSString *_originalText;
    
    NSArray *_titleArray;
    NSMutableArray *_constructionCompany;
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
    self.title = @"新建项目";
    [self initData];
    [self initViews];
}
- (void)initData
{
    if (!_project)
    {
        _project = [[Project alloc] init];
    }
    _constructionCompany = [[NSMutableArray alloc] init];
    ConstructionCompany *company = [[ConstructionCompany alloc] init];
    [_constructionCompany addObject:company];
    
    _titleArray = @[@"项目名称", @"项目区域", @"项目标段", @"评估轮次", @"监理单位", @"评估日期", @"评估组长"];
    _propertiesArray = @[@"name", @"district", @"site", @"turn", @"supervisory", @"measure_date", @"captain"];

}

static NSString *inputCell = @"InputCell";
static NSString *inputCell2 = @"InputCell2";
static NSString *inputCell3 = @"InputCell3";
static NSString *inputCell4 = @"InputCell4";
- (void)initViews
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = item;
    
    UITableView *tableView = [[UITableView alloc] initForAutoLayout];
    [self.view addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView autoPinEdgesToSuperviewEdges];
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
    if([User saveProject:_project])
    {
        [SVProgressHUD showSuccessWithStatus:@"保存完成"];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    }
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
            return _project.members.count > 0? _project.members.count : 1;
            break;
        case 2:
            return _constructionCompany.count;
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
            if (indexPath.row == 5)
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
            if (_project.members.count > 0)
            {
                cell.memberTextField.text = _project.members[indexPath.row];
            }
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
            return cell;
        }
            break;
        case 3:
        {
            InputCell3 *cell = [tableView dequeueReusableCellWithIdentifier:inputCell3 forIndexPath:indexPath];
            cell.addressTextField.delegate = self;
            cell.chargemanTextField.delegate = self;
            cell.areaTextField.delegate = self;
            cell.progressTextField.delegate = self;
            cell.end_dateTextField.delegate = self;
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
            return 240;
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
                /*natomic, copy) NSString *name;
                 @property (nonatomic, copy) NSString *district;
                 @property (nonatomic, copy) NSString *site;
                 @property (nonatomic, copy) NSString *turn;
                 @property (nonatomic, strong) NSArray *supervisory;
                 @property (nonatomic, copy) NSString *measure_date;
                 @property (nonatomic, copy) NSString *captain;*/
                InputCell *c = (InputCell *)cell;
                [_project setValue:c.textField.text forKey:_propertiesArray[indexPath.row]];
            }
                break;
            case 1:
            {
                InputCell4 *c = (InputCell4 *)cell;
                [_project.members insertObject:c.memberTextField.text atIndex:indexPath.row];
            }
                break;
            case 2:
            {
                InputCell2 *c = (InputCell2 *)cell;
            }
                break;
            case 3:
            {
                InputCell3 *c = (InputCell3 *)cell;
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
        if (_project.members.count == 0)
        {
            return NO;
        }
    }
    if (indexPath.section == 2)
    {
        if (_constructionCompany.count == 1)
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
             [_constructionCompany removeObjectAtIndex:indexPath.row];
        }
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}


#pragma mark - 添加施工单位
- (void)addCompany:(UIButton *)button
{
    ConstructionCompany *company = [[ConstructionCompany alloc] init];
    [_constructionCompany addObject:company];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

- (void)addMember:(UIButton *)button
{
    [_project.members addObject:@""];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
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
