//
//  SignViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/15.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "SignViewController.h"
#import "LSDrawView.h"
@interface SignViewController ()
@property (nonatomic, strong) LSDrawView *drawView;
@end

@implementation SignViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = item;
    
    _drawView = [[LSDrawView alloc] initForAutoLayout];
    [self.view insertSubview:_drawView atIndex:0];
    [_drawView autoCenterInSuperview];
    [_drawView autoSetDimensionsToSize:CGSizeMake(self.view.width, self.view.height)];
    _drawView.backgroundColor = [UIColor whiteColor];
    _drawView.brushColor = [UIColor blackColor];
    _drawView.brushWidth = 3;
}

- (void)save
{
    [_drawView save];
     UIImageWriteToSavedPhotosAlbum(_drawView.editedImage, nil, nil, nil);
    [SVProgressHUD showSuccessWithStatus:@"签名保存成功"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)undoButtonClick:(id)sender
{
    [_drawView clean];
}

- (void)didReceiveMemoryWarning
{
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
