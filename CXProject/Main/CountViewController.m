//
//  CountViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/3/22.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "CountViewController.h"
#import "PureLayout.h"
@interface CountViewController ()

@end

@implementation CountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIRefreshControl *control = [[UIRefreshControl alloc] init];
    control.attributedTitle = [[NSAttributedString alloc] initWithString:@"加载中..."];
    control.tintColor = [UIColor redColor];
    [control addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.refreshControl = control;
    

}

- (void)refreshAction:(UIRefreshControl *)control
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [control endRefreshing];
    });
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
