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

#import "MHKeyboard.h"
#import "UIMyDatePicker.h"
#import "ConstructionCompany.h"
#import "Member.h"
@interface NewProjectViewController () <UITableViewDataSource, UITableViewDelegate, UIMyDatePickerDelegate, UITextFieldDelegate>
{
    UIMyDatePicker *_datePicker;
    UITextField *_activeTextField;

    NSArray *_titleArray;
    NSMutableArray *_memberArray;
    NSMutableArray *_constructionCompany;
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
    _constructionCompany = [[NSMutableArray alloc] init];
    ConstructionCompany *company = [[ConstructionCompany alloc] init];
    [_constructionCompany addObject:company];
    
    
    _memberArray = [[NSMutableArray alloc] init];
    Member *member = [[Member alloc] init];
    [_memberArray addObject:member];
    
    _titleArray = @[@"项目名称", @"项目区域", @"项目标段", @"评估轮次", @"监理单位", @"评估日期", @"评估组长"];
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
            return _memberArray.count;
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
            cell.nameLabel.text = _titleArray[indexPath.row];
            cell.textField.delegate = self;
            if (indexPath.row == 5)
            {
                cell.textField.inputView = _datePicker;
            }
            return cell;
           
        }
            break;
        case 1:
        {
            InputCell4 *cell = [tableView dequeueReusableCellWithIdentifier:inputCell4 forIndexPath:indexPath];
            [cell.addButton addTarget:self action:@selector(addMember:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
            break;
        case 2:
        {
            InputCell2 *cell = [tableView dequeueReusableCellWithIdentifier:inputCell2 forIndexPath:indexPath];
            [cell.addButton addTarget:self action:@selector(addCompany:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
            break;
        case 3:
        {
            InputCell3 *cell = [tableView dequeueReusableCellWithIdentifier:inputCell3 forIndexPath:indexPath];
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
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
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
        if (_memberArray.count == 1)
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
             [_memberArray removeObjectAtIndex:indexPath.row];
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
    Member *member = [[Member alloc] init];
    [_memberArray addObject:member];
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
