//
//  M_ViewFileViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/1.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "M_ViewFileViewController.h"
#import "M_CollectionViewController.h"
#import "FileCell.h"
@interface M_ViewFileViewController () <ViewPagerDataSource, ViewPagerDelegate, DZNEmptyDataSetSource>

@property (nonatomic, strong) NSMutableArray *controllerArray;
@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSArray *recentArray;
@property (nonatomic, strong) NSArray *historyArray;
@end

@implementation M_ViewFileViewController
static NSString *fileCellIdentifier = @"FileCell";
static NSString *headerIdentifier = @"sectionHeader";
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initViews];
}

- (void)initData
{
    self.dataSource = self;
    self.delegate = self;
    
    self.controllerArray = [[NSMutableArray alloc] init];
    if ([self.fileType isEqualToString:@"表格"])
    {
        self.titleArray = @[@"近期表格", @"历史表格"];
    }
    else
    {
        self.titleArray = @[@"近期报告", @"历史报告"];
    }
    _historyArray = @[@(0), @(0), @(0), @(0), @(0), @(0), @(0)];
    for (int i = 0; i<self.titleArray.count ; i++)
    {
        M_CollectionViewController *c = [[M_CollectionViewController alloc] init];
        c.fileType = self.fileType;
        if (i == 0)
        {
            c.sourceArray = _recentArray;
        }
        else
        {
            c.sourceArray = _historyArray;
        }
        [self.controllerArray addObject:c];
    }
}

- (void)initViews
{
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager
{
    return _titleArray.count;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index
{
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.0];
    label.text = [NSString stringWithFormat:@"%@", _titleArray[index]];
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
    
}

- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value
{
    switch (option) {
        case ViewPagerOptionTabWidth:
            return DEF_SCREEN_WIDTH/2.0;
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
            return [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
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
