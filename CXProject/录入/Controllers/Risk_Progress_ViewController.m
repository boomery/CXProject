//
//  Risk_Progress_ViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/5.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "Risk_Progress_ViewController.h"
#import "Risk_Progress_CollectionViewController.h"
#import "DataProvider.h"
@interface Risk_Progress_ViewController () <ViewPagerDelegate, ViewPagerDataSource>

@property (nonatomic, strong) NSMutableArray *controllerArray;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation Risk_Progress_ViewController
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
    self.titleArray = @[@"安全文明", @"质量风险", @"优秀照片"];
    NSArray *array = [DataProvider riskProgressItems];
    
    for (int i = 0; i < self.titleArray.count && i < array.count; i++)
    {
        Risk_Progress_CollectionViewController *c = [[Risk_Progress_CollectionViewController alloc] init];
        if (i < array.count - 1)
        {
            Event *event = array[i];
            c.sourceArray = event.events;
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
            return DEF_SCREEN_WIDTH/3.0;
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
