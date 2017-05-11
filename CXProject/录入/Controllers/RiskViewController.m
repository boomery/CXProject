//
//  RiskViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/5/11.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "RiskViewController.h"

@interface RiskViewController () <ViewPagerDataSource, ViewPagerDelegate>
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *controllerArray;
@end

@implementation RiskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataSource = self;
    self.delegate = self;
    self.controllerArray = [[NSMutableArray alloc] init];
    self.titleArray = @[@"户内观感",@"园建观感",@"公共部位",@"外立面"];
    for (int i = 0; i<self.titleArray.count ; i++)
    {
        UIViewController *c = [[UIViewController alloc] init];
        [self.controllerArray addObject:c];
    }
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
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value
{
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 1.0;
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
