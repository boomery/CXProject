//
//  RiskViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/5/11.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "RiskViewController.h"
#import "RiskLineCell.h"
#import "MeasureRiskViewController.h"
@interface RiskViewController () <ViewPagerDataSource, ViewPagerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (nonatomic, strong) NSArray *eventsArray;
@property (nonatomic, strong) NSArray *leftArray;
@property (nonatomic, strong) NSArray *rightArray;
@property (nonatomic, strong) NSMutableArray *controllerArray;
@end

@implementation RiskViewController

static NSString *Identifier = @"riskLinecell";
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataSource = self;
    self.delegate = self;
    self.controllerArray = [[NSMutableArray alloc] init];
    self.eventsArray = [DataProvider riskItems];
    for (int i = 0; i<self.eventsArray.count ; i++)
    {
        UIViewController *c = [[UIViewController alloc] init];
        c.view.backgroundColor = [UIColor whiteColor];
        [self.controllerArray addObject:c];
    }
    self.leftTableView.tableFooterView = [[UIView alloc] init];
    self.rightTableView.tableFooterView = [[UIView alloc] init];
    [self.leftTableView registerNib:[UINib nibWithNibName:@"RiskLineCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:Identifier];
    [self.rightTableView registerNib:[UINib nibWithNibName:@"RiskLineCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:Identifier];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _leftTableView)
    {
        return _leftArray.count;
    }
    else
    {
        return _rightArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RiskLineCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    cell.textLabel.font = LABEL_FONT;
    cell.textLabel.numberOfLines = 0;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   
    Event *event = nil;
    if (tableView == _leftTableView)
    {
        event = _leftArray[indexPath.row];
    }
    else
    {
        event = _rightArray[indexPath.row];
    }
    if (event.events.count == 0)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = event.name;
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RiskLineCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = YES;
    
    Event *Tevent = self.eventsArray[self.activeTabIndex];
    NSString *position = Tevent.name;
    
    Event *levent = _leftArray[_leftTableView.indexPathForSelectedRow.row];

    

    if (tableView == _leftTableView)
    {
        position = [position stringByAppendingString:[NSString stringWithFormat:@"/%@",levent.name]];
        _rightArray = levent.events;
        [_rightTableView reloadData];
        if (_rightArray.count == 0)
        {
            MeasureRiskViewController *riskVC = [[MeasureRiskViewController alloc] init];
            riskVC.event = levent;
            riskVC.position = position;
            [self.navigationController pushViewController:riskVC animated:YES];
        }
    }
    else
    {
        Event *revent = _rightArray[indexPath.row];
        position = [position stringByAppendingString:[NSString stringWithFormat:@"/%@",levent.name]];
        position = [position stringByAppendingString:[NSString stringWithFormat:@"/%@",revent.name]];
        MeasureRiskViewController *riskVC = [[MeasureRiskViewController alloc] init];
        riskVC.event = revent;
        riskVC.position = position;
        [self.navigationController pushViewController:riskVC animated:YES];
    }
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager
{
    return _eventsArray.count;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index
{
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.0];
    Event *event = _eventsArray[index];
    label.text = [NSString stringWithFormat:@"%@", event.name];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index
{
    return _controllerArray[index];
}

#pragma mark - ViewPagerDelegate
- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index
{
    Event *event = _eventsArray[index];
    _leftArray = event.events;
    [self.leftTableView reloadData];
    if (_leftArray.count > 0)
    {
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        Event *event = _leftArray[0];
        _rightArray = event.events;
        [self.rightTableView reloadData];
    }
}

- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value
{
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
            break;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
            break;
        case ViewPagerOptionTabLocation:
            return 1.0;
            break;
        default:
            break;
    }
    
    return value;
}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color
{
    switch (component) {
        case ViewPagerIndicator:
            return [UIColor colorWithRed:0.92 green:0.20 blue:0.15 alpha:1.00];
            break;
        case ViewPagerTabsView:
            return [UIColor whiteColor];
            break;
        default:
            break;
    }
    return color;
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
