//
//  ExtractionResultViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/27.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "ExtractionResultViewController.h"
#import "ExtactResultCell.h"
@interface ExtractionResultViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSArray *_titleArray;
    NSArray *_titleArray2;
    NSMutableArray *_titleArray3;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ExtractionResultViewController

static NSString *extactResultCell = @"extactResultCell";

- (void)dealloc
{
    [MHKeyboard removeRegisterTheViewNeedMHKeyboard];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _titleArray = @[@"抽取标段", @"所属项目", @"所属城市", @"所属区域", @"所属集团", @"抽签轮次", @"抽检责任人"];
    _titleArray2 = @[@"抽检名称", @"抽检范围", @"抽取样本", @"抽取结果", @"抽取时间"];
    _titleArray3 = [[NSMutableArray alloc] init];
    [_titleArray3 addObject:@"抽检范围"];
    [_titleArray3 addObject:@"备注"];

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ExtactResultCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:extactResultCell];
    
    [MHKeyboard addRegisterTheViewNeedMHKeyboard:self.view];
    // Do any additional setup after loading the view from its nib.
}

- (void)addResult
{
    [_titleArray3 addObject:@"抽检范围"];
    [_titleArray3 addObject:@"备注"];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_titleArray3.count-2 inSection:2],[NSIndexPath indexPathForRow:_titleArray3.count-1 inSection:2]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return _titleArray.count;
            break;
        case 1:
            return _titleArray2.count;
            break;
        case 2:
            return _titleArray3.count;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExtactResultCell *cell = [tableView dequeueReusableCellWithIdentifier:extactResultCell forIndexPath:indexPath];
    cell.addButton.hidden = YES;
    if (indexPath.section == 0)
    {
        cell.textField.enabled = NO;
        cell.nameLabel.text = _titleArray[indexPath.row];
    }
    else if (indexPath.section == 1)
    {
        cell.textField.enabled = NO;
        cell.nameLabel.text = _titleArray2[indexPath.row];
    }
    else
    {
        if (indexPath.row == 0)
        {
            cell.addButton.hidden = NO;
            [cell.addButton addTarget:self action:@selector(addResult) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.nameLabel.text = _titleArray3[indexPath.row];
        cell.textField.enabled = YES;
        cell.textField.delegate = self;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 0.5)];
    view.backgroundColor = LINE_COLOR;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}

#pragma mark - UIScrollViewDelegate
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
