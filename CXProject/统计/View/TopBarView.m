//
//  TopBarView.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/3/23.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//
#define LINE_COLOR [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.00]
#define BUTTON_TINT_COLOR [UIColor colorWithRed:0.93 green:0.36 blue:0.16 alpha:1.00]
#import "TopBarView.h"
#import "CountViewController.h"
@interface TopBarView () <UITableViewDelegate, UITableViewDataSource>
//下拉列表
@property (nonatomic, strong) UITableView *tableView;
//记录选中按钮
@property (nonatomic, strong) UIButton *lastButton;
//是否显示下拉列表
@property (nonatomic, assign) BOOL shouldShowTab;
//下拉排序按钮
@property (nonatomic, strong) UIButton *sortButton;
//下拉列表显示的数据
@property (nonatomic, strong) NSArray *detailArray;
@end
@implementation TopBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        //画下划线
        UIView *lineView = [[UIView alloc] initForAutoLayout];
        [self addSubview:lineView];
        [lineView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
        [lineView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
        [lineView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
        [lineView autoSetDimension:ALDimensionHeight toSize:0.5];
        lineView.backgroundColor = LINE_COLOR;
    }
    return self;
}
#pragma mark - 布局界面
- (void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (int i = 0; i < _titleArray.count; i ++)
    {
        UIButton *button = [[UIButton alloc] initForAutoLayout];
        [self addSubview:button];
        [views addObject:button];
        
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:BUTTON_TINT_COLOR forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0)
        {
            _sortButton = button;
            button.selected = YES;
            _lastButton = button;
        }
        
        if (i < _titleArray.count - 1)
        {
            UIView *lineView = [UIView newAutoLayoutView];
            [self addSubview:lineView];
            lineView.backgroundColor = LINE_COLOR;
            [lineView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:button];
            [lineView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
            [lineView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
            [lineView autoSetDimension:ALDimensionWidth toSize:0.5];
        }
    }
    [views autoSetViewsDimension:ALDimensionHeight toSize:40];
    [views autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:10.0 insetSpacing:YES matchedSizes:YES];
    [[views firstObject] autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0) style:UITableViewStylePlain];
        [window addSubview:tableView];
        tableView.dataSource = self;
        tableView.delegate = self;
        _tableView = tableView;
        
        _detailArray = @[@"综合排序", @"合格率", @"问题数由高到低", @"问题数由高到低"];
    }
    return _tableView;
}

#pragma mark - 更新控件坐标
- (void)setOffSet:(CGFloat)offSet
{
    _offSet = offSet;
    [self.tableView setTop:(64 + self.height + _offSet)];
}

#pragma mark - 代理方法
- (void)buttonClicked:(UIButton *)button
{
    if (button != _lastButton)
    {
        _lastButton.selected = NO;
        _lastButton = button;
        _lastButton.selected = YES;
    }
    if (button.tag == 0)
    {
        _shouldShowTab = !_shouldShowTab;
        [self tableViewAnimateShouldShow:_shouldShowTab];
    }
    else
    {
        [self tableViewAnimateShouldShow:NO];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CountCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    cell.textLabel.text = _detailArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [_sortButton setTitle:_detailArray[indexPath.row] forState:UIControlStateSelected];
    [_sortButton setTitle:_detailArray[indexPath.row] forState:UIControlStateNormal];
    
    [self tableViewAnimateShouldShow:NO];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = 0;
}

#pragma mark - 动画部分
- (void)tableViewAnimateShouldShow:(BOOL)shouldShow
{
    _shouldShowTab = shouldShow;
    if (shouldShow)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.frame = CGRectMake(0, 64 + self.height + _offSet, self.width, 4*44);
        }];
    }
   else
   {
       [UIView animateWithDuration:0.3 animations:^{
           self.tableView.frame = CGRectMake(0, 64 + self.height + _offSet, self.width, 0);
       }];
   }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
