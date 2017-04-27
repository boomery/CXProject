//
//  MeasureRiskViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/27.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "MeasureRiskViewController.h"
#import <Photos/Photos.h>
#import "PhotoEditorViewController.h"
#import "CXDataBaseUtil.h"
@interface MeasureRiskViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    __weak IBOutlet NSLayoutConstraint *_heightConstraint;
    //拍照相关变量
    BOOL _showPhoto;
    UIImageView *_imageView;
    UIView *_backView;
}
@end

@implementation MeasureRiskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IS_IPHONE_5)
    {
        _heightConstraint.constant = 33;
    }
    else
    {
        _heightConstraint.constant = 44;
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"拍照" style:UIBarButtonItemStylePlain target:self action:@selector(takePhoto)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"查看" style:UIBarButtonItemStylePlain target:self action:@selector(viewPhoto)];
    
    self.navigationItem.rightBarButtonItems = @[item, item2];
    // Do any additional setup after loading the view.
}

- (void)takePhoto
{
//    if (![self exsistMeasureResultForIndexPath:_indexPath])
//    {
//        [SVProgressHUD showErrorWithStatus:@"请先保存录入数据后再拍照"];
//        return;
//    }
    _showPhoto = NO;
    [_imageView removeFromSuperview];
    [_backView removeFromSuperview];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action){
        
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            [SVProgressHUD showErrorWithStatus:@"需要访问您的相机。\n请启用-设置/隐私/相机"];
            return;
        }
        
        //先判断相机是否可用
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        }
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //选择图片
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewPhoto
{
//    MeasureResult *res = [self exsistMeasureResultForIndexPath:_indexPath];
//    if (res.measurePhoto.length != 0)
//    {
        if (!_showPhoto)
        {
            [self.view endEditing:YES];
            UIView *view = [[UIView alloc] initForAutoLayout];
            view.backgroundColor = [UIColor blackColor];
            view.alpha = 0.4;
            _backView = view;
            [self.view addSubview:view];
            [view autoPinEdgesToSuperviewEdges];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            tap.numberOfTapsRequired = 1;
            
            [view addGestureRecognizer:tap];
            
            UIImageView *imageView = [[UIImageView alloc] initForAutoLayout];
            [self.view addSubview:imageView];
            _imageView = imageView;
            [imageView autoCenterInSuperview];
            [imageView autoSetDimensionsToSize:CGSizeMake(300, 300)];
//            imageView.image = [UIImage imageWithContentsOfFile:[CXDataBaseUtil imagePathForName:res.measurePhoto]];
            _showPhoto = !_showPhoto;
        }
//    }
//    else
//    {
//        [SVProgressHUD showErrorWithStatus:@"请先拍照后查看"];
//    }
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    _showPhoto = NO;
    [_imageView removeFromSuperview];
    [tap.view removeFromSuperview];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    PhotoEditorViewController *editor = [[PhotoEditorViewController alloc] init];
    [picker pushViewController:editor animated:YES];
    editor.image = image;
    
    editor.imageBlock = ^(UIImage *image){
        
        NSString *imageName = [CXDataBaseUtil imageName];
        //其中参数0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
        if ( [UIImageJPEGRepresentation(image, 0.5) writeToFile:[CXDataBaseUtil imagePathForName:imageName]  atomically:YES])
        {
//            MeasureResult *res = [self exsistMeasureResultForIndexPath:_indexPath];
//            if (res.measurePhoto.length != 0)
//            {
//                [[NSFileManager defaultManager] removeItemAtPath:[CXDataBaseUtil imagePathForName:res.measurePhoto] error:nil];
//                NSLog(@"移除旧照片");
//            }
//            res.measurePhoto = imageName;
//            [MeasureResult insertNewMeasureResult:res];
            [SVProgressHUD showSuccessWithStatus:@"照片保存成功"];
        }
        
        [picker dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            // 改变状态栏的颜色  改变为白色
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    };
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
