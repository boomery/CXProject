//
//  Risk_Progress_ItemViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/7.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "Risk_Progress_ItemViewController.h"
#import "Risk_Progress_DetailViewController.h"
@interface Risk_Progress_ItemViewController ()
{
    NSArray *_titleArray;
}
@end

@implementation Risk_Progress_ItemViewController
- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style])
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
//    self.navigationItem.rightBarButtonItem = item;
    [self initData];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)save
{
    
}

- (void)initData
{
    _titleArray = self.event.events;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = LABEL_FONT;
        cell.textLabel.numberOfLines = 0;
    }
    Event *event = _titleArray[indexPath.row];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Event *event = _titleArray[indexPath.row];

    if (event.events.count > 0)
    {
        Risk_Progress_ItemViewController *riskVC = [[Risk_Progress_ItemViewController alloc] init];
        riskVC.event = event;
        riskVC.itemArray = [[NSMutableArray alloc] initWithArray:_itemArray];
        riskVC.saveBlock = _saveBlock;
        [riskVC.itemArray addObject:event];
        [self.navigationController pushViewController:riskVC animated:YES];
    }
    else
    {
        [self.itemArray addObject:event];
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[Risk_Progress_DetailViewController class]]) {
                Risk_Progress_DetailViewController *vc =(Risk_Progress_DetailViewController *)controller;
                self.saveBlock(_itemArray);
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event *event = _titleArray[indexPath.row];
    NSDictionary *attribute = @{NSFontAttributeName:LABEL_FONT};
    CGSize size = [event.name boundingRectWithSize:CGSizeMake(DEF_SCREEN_WIDTH*0.8 , MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size.height + 30;
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
