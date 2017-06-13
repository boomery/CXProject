//
//  Risk_Progress_PhotoEditorViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/5.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "Risk_Progress_PhotoEditorViewController.h"
#import "Risk_Progress_DetailViewController.h"
#import "FileManager.h"
@interface Risk_Progress_PhotoEditorViewController ()
{
    UIButton *_selectedButton;
    __weak IBOutlet UIButton *_firstButton;
    __weak IBOutlet LSDrawView *_drawView;
    Photo *_photo;
}
@end

@implementation Risk_Progress_PhotoEditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
    _drawView.backgroundColor = [UIColor blackColor];
    _drawView.brushColor = [UIColor redColor];
    _drawView.brushWidth = 3;
    _drawView.shapeType = LSShapeEllipse;
    _drawView.backgroundImage = _image;
    
    _firstButton.selected = YES;
    _firstButton.backgroundColor = [UIColor colorWithRed:0.23 green:0.56 blue:0.96 alpha:1.00];
    _selectedButton = _firstButton;
    
    NSString *imageName = [FileManager imageName];
    Photo *photo = [[Photo alloc] init];
    photo.projectID = [User editingProject].fileName;
    photo.photoName = imageName;
    photo.save_time = [FileManager currentTime];
    photo.place = @"";
    photo.kind = [Photo textKindForIndex:0];
    photo.item = @"";
    photo.subItem = @"";
    photo.subItem2 = @"";
    photo.subItem3 = @"";
    photo.responsibility = @"";
    photo.repair_time = @"";
    photo.image = nil;
    _photo = photo;
}

- (IBAction)kindButtonClick:(UIButton *)sender
{
    if (sender != _selectedButton)
    {
        _selectedButton.backgroundColor = [UIColor whiteColor];
        _selectedButton.selected = NO;
        _selectedButton = sender;
        _selectedButton.backgroundColor = [UIColor colorWithRed:0.23 green:0.56 blue:0.96 alpha:1.00];
        _selectedButton.selected = YES;
    }
}

- (IBAction)undoButtonClick:(id)sender
{
    [_drawView unDo];
}

- (IBAction)editDetail:(id)sender
{
    [_drawView save];
    
    Risk_Progress_DetailViewController *detailVC = [[Risk_Progress_DetailViewController alloc] init];
    
    _photo.image = _drawView.editedImage;
    _photo.kind = [Photo textKindForIndex:_selectedButton.tag];
    detailVC.photo = _photo;

    detailVC.saveBlock = ^(Photo *photo){
        _photo = photo;
    };
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (IBAction)confirmButtonClick:(id)sender
{
    [_drawView save];
    self.imageBlock(_photo);
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
