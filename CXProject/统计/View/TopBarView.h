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

- (void)tableViewAnimateShouldShow:(BOOL)shouldShow;

@end



@protocol TopBarViewDelegate <NSObject>

//@required
//
//@optional

- (void)topBarViewDidClickedWithIndex:(NSInteger)index topBarView:(TopBarView *)topBarView;

@end
