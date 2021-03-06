//
//  TopBarView.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/3/23.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface TopBarView : UIView

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, assign) CGFloat offSet;
//下拉列表
@property (nonatomic, strong) UITableView *tableView;

- (void)tableViewAnimateShouldShow:(BOOL)shouldShow;

@end



@protocol TopBarViewDelegate <NSObject>

//@required
//
//@optional
- (void)topBarViewDidClickedSiftButton;
- (void)topBarViewDidClickedChangeButton;
- (void)topBarViewDidClickedWithIndex:(NSInteger)index text:(NSString *)text topBarView:(TopBarView *)topBarView;

@end
