//
//  RiskViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/5/11.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "RiskViewController.h"
#import "MeasureRiskViewController.h"
#import "PureLabelCell.h"
@interface RiskViewController () <ViewPagerDataSource, ViewPagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)  UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *eventsArray;//顶部标题
@property (nonatomic, strong) NSArray *leftArray;//第二个区数据源
@property (nonatomic, strong) NSArray *rightArray;//第三个区数据源
@property (nonatomic, assign) NSInteger firstSelectedRow;
@property (nonatomic, assign) NSInteger secondSelectedRow;
@property (nonatomic, assign) NSInteger thirdSelectedRow;
@property (nonatomic, strong) NSMutableArray *controllerArray;
@end

@implementation RiskViewController

static NSString *labelCellIdentifier = @"PureLabelCell";
static NSString *headerIdentifier = @"sectionHeader";
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
    self.dataSource = self;
    self.delegate = self;
    self.controllerArray = [[NSMutableArray alloc] init];
    self.eventsArray = [DataProvider riskItems];
    for (int i = 0; i<self.eventsArray.count ; i++)
    {
        UIViewController *c = [[UIViewController alloc] init];
        c.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
        [self.controllerArray addObject:c];
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 128, DEF_SCREEN_WIDTH-20, DEF_SCREEN_HEIGHT - 128) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];

    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:@"PureLabelCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:labelCellIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 10;
    }
    else if (section == 1)
    {
        return _leftArray.count;
    }
    else if(section == 2)
    {
        return _rightArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PureLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:labelCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.section == 0)
    {
        if (indexPath.row == _firstSelectedRow)
        {
            cell.backgroundColor = [UIColor colorWithRed:0.27 green:0.57 blue:0.87 alpha:1.00];
        }
        cell.label.text = @"1#202202";
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == _secondSelectedRow)
        {
            cell.backgroundColor = [UIColor colorWithRed:0.27 green:0.57 blue:0.87 alpha:1.00];
        }
        Event *event = _leftArray[indexPath.row];
        cell.label.text = event.name;
    }
    else if(indexPath.section == 2)
    {
        if (indexPath.row == _thirdSelectedRow)
        {
            cell.backgroundColor = [UIColor colorWithRed:0.27 green:0.57 blue:0.87 alpha:1.00];
        }
        Event *event = _rightArray[indexPath.row];
        cell.label.text = event.name;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Event *Tevent = self.eventsArray[self.activeTabIndex];
    NSString *position = Tevent.name;

    if (indexPath.section == 0)
    {
        _firstSelectedRow = indexPath.row;
        _secondSelectedRow = 0;
        _thirdSelectedRow = 0;
        [self.collectionView reloadData];
    }
    else if (indexPath.section == 1)
    {
        _secondSelectedRow = indexPath.row;
        _thirdSelectedRow = 0;
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];


        
        Event *event = _leftArray[indexPath.row];
        _rightArray = event.events;
        if (_rightArray.count > 0)
        {
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
        else
        {
            Event *levent = _leftArray[_secondSelectedRow];
            position = [position stringByAppendingString:[NSString stringWithFormat:@"/%@",levent.name]];
            MeasureRiskViewController *riskVC = [[MeasureRiskViewController alloc] init];
            riskVC.event = levent;
            riskVC.position = position;
            [self.navigationController pushViewController:riskVC animated:YES];
        }
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
    }
    else
    {
        _thirdSelectedRow = indexPath.row;
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
        
        Event *levent = _leftArray[_secondSelectedRow];
        Event *revent = _rightArray[indexPath.row];
        position = [position stringByAppendingString:[NSString stringWithFormat:@"/%@",levent.name]];
        position = [position stringByAppendingString:[NSString stringWithFormat:@"/%@",revent.name]];
        MeasureRiskViewController *riskVC = [[MeasureRiskViewController alloc] init];
        riskVC.event = revent;
        riskVC.position = position;
        [self.navigationController pushViewController:riskVC animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(DEF_SCREEN_WIDTH, 5);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
    UIView *lineView = [UIView newAutoLayoutView];
    lineView.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.88 alpha:1.00];
    [view addSubview:lineView];
    [lineView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:view];
    [lineView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:view];
    [lineView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:view];
    [lineView autoSetDimension:ALDimensionHeight toSize:0.5];
    return view;
}

#pragma mark - UICollectionViewDelegateFlowLayout
//定义每个Cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};

    Event *event = nil;
    if (indexPath.section == 0)
    {
        return CGSizeMake(100, 44);
    }
    else if (indexPath.section == 1)
    {
        event = _leftArray[indexPath.row];
        CGSize size = [event.name boundingRectWithSize:CGSizeMake(MAXFLOAT , 44)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        if (size.width < 80)
        {
            size.width = 80;
        }
        return CGSizeMake(size.width, 44);
    }
    else if(indexPath.section == 2)
    {
        event = _rightArray[indexPath.row];
        CGSize size = [event.name boundingRectWithSize:CGSizeMake(MAXFLOAT , 44)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        if (size.width < 80)
        {
            size.width = 80;
        }
        return CGSizeMake(size.width, 44);
    }
    return CGSizeMake(0, 0);
}
    
    //定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);//分别为上、左、下、右
}

//    //这个是两行cell之间的间距（上下行cell的间距）
//    - (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;

//    //两个cell之间的间距（同一行的cell的间距）
//    - (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;


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
    if (_leftArray.count > 0)
    {
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        Event *event = _leftArray[0];
        _rightArray = event.events;
        if (_rightArray.count > 0)
        {
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    }
    _firstSelectedRow = 0;
    _secondSelectedRow = 0;
    _thirdSelectedRow = 0;
    [self.collectionView reloadData];
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
