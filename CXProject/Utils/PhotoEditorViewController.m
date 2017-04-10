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
    self.view.backgroundColor = [UIColor whiteColor];
    
    _drawView = [[LSDrawView alloc] initForAutoLayout];
    [self.view addSubview:_drawView];
    [_drawView autoCenterInSuperview];
    [_drawView autoSetDimensionsToSize:CGSizeMake(self.view.width, self.view.width)];
    _drawView.brushColor = [UIColor redColor];
    _drawView.brushWidth = 3;
    _drawView.shapeType = LSShapeEllipse;
    
    _drawView.backgroundImage = _image;
    
    UIButton *button = [[UIButton alloc] initForAutoLayout];
    [self.view addSubview:button];
//    button 
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
