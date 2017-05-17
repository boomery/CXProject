//
//  PhotoEditorViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/1.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "PhotoEditorViewController.h"

@interface PhotoEditorViewController ()

@end

@implementation PhotoEditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    if (self.haveTag)
    {
        UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[@"问题照片",@"优秀照片"]];
        [self.view addSubview:seg];
        seg.frame = CGRectMake(10, 84, DEF_SCREEN_WIDTH - 20, 44);
        seg.tintColor = THEME_COLOR;
        seg.selectedSegmentIndex = 0;
    }
    
    _drawView = [[LSDrawView alloc] initForAutoLayout];
    [self.view addSubview:_drawView];
    [_drawView autoCenterInSuperview];
    [_drawView autoSetDimensionsToSize:CGSizeMake(self.view.width*0.8, self.view.width*0.8)];
    _drawView.backgroundColor = [UIColor colorWithRed:0.83 green:0.18 blue:0.13 alpha:1.00];
    _drawView.brushColor = [UIColor redColor];
    _drawView.brushWidth = 3;
    _drawView.shapeType = LSShapeEllipse;
    
    _drawView.backgroundImage = _image;

    // Do any additional setup after loading the view.
}
- (IBAction)undoButtonClick:(id)sender
{
    [_drawView unDo];
}
- (IBAction)confirmButtonClick:(id)sender
{
    [_drawView save];
    self.imageBlock(_drawView.editedImage);
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
