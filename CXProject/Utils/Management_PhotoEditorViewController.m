//
//  Management_PhotoEditorViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/15.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "Management_PhotoEditorViewController.h"
#import "Risk_Progress_DetailViewController.h"
#import "FileManager.h"
@interface Management_PhotoEditorViewController ()
{
    BOOL _haveSaveDetail;
    __weak IBOutlet LSDrawView *_drawView;
    Photo *_photo;
}
@end

@implementation Management_PhotoEditorViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
    _drawView.backgroundColor = [UIColor blackColor];
    _drawView.brushColor = [UIColor redColor];
    _drawView.brushWidth = 3;
    _drawView.shapeType = LSShapeEllipse;
    _drawView.backgroundImage = _image;
    
    NSString *imageName = [FileManager imageName];
    Photo *photo = [[Photo alloc] init];
    photo.projectID = [User editingProject].fileName;
    photo.photoName = imageName;
    photo.save_time = [FileManager currentTime];
    photo.place = @"";
    photo.kind = @"管理行为";
    photo.item = @"";
    photo.subItem = @"";
    photo.subItem2 = @"";
    photo.subItem3 = @"";
    photo.responsibility = @"";
    photo.repair_time = @"";
    photo.image = nil;
    _photo = photo;
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
    _photo.item = self.kindName;
    detailVC.photo = _photo;
    
    detailVC.saveBlock = ^(Photo *photo){
        _haveSaveDetail =YES;
        _photo = photo;
    };
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (IBAction)confirmButtonClick:(id)sender
{
    if (!_haveSaveDetail)
    {
        [SVProgressHUD showInfoWithStatus:@"请先编辑详细信息中的检查项"];
    }
    else
    {
        [_drawView save];
        _photo.image = _drawView.editedImage;
        self.imageBlock(_photo);
    }
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
