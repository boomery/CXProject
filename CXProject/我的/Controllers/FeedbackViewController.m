//
//  FeedbackViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/28.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "FeedbackViewController.h"
#import "UIPlaceHolderTextView.h"
#import "AddImageView.h"
#import <Photos/Photos.h>
#import "WMPhotoPickerController.h"
#import "ImageModel.h"
@interface FeedbackViewController () <UITextViewDelegate, AddImageViewDelegate, WMPhotoPickerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong)UIPlaceHolderTextView   *suggestionTextView;
@property (nonatomic, strong)AddImageView *addImageView;
@property (nonatomic, strong) NSMutableArray *savedModelArray;
@end

@implementation FeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.savedModelArray = [[NSMutableArray alloc] init];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    
    self.suggestionTextView = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(20, 20, DEF_SCREEN_WIDTH-40,130/568.0 *DEF_SCREEN_HEIGHT)];
    self.suggestionTextView.scrollEnabled = YES;
    self.suggestionTextView.font        = [UIFont systemFontOfSize:13.5];
    self.suggestionTextView.textColor   = [UIColor blackColor];
    self.suggestionTextView.placeholder =@"详细描述，有益解答";
    self.suggestionTextView.placeholderColor = LINE_COLOR;
    self.suggestionTextView.delegate    = self;
    self.suggestionTextView.layer.cornerRadius = 5;
    self.suggestionTextView.clipsToBounds = YES;
    self.suggestionTextView.returnKeyType = UIReturnKeyDone;
    self.suggestionTextView.layer.borderWidth = 0.5;;
    self.suggestionTextView.layer.borderColor = [LINE_COLOR CGColor];
    [self.view addSubview:self.suggestionTextView];
    
    //
    UILabel *addImageLab= [[UILabel alloc] initWithFrame:CGRectMake(20 ,self.suggestionTextView.bottom + 20,65 ,30)];
    addImageLab.text = @"添加图片:";
    addImageLab.font = [UIFont systemFontOfSize:13.5];
    [self.view addSubview:addImageLab];
    UILabel *imageCountLB= [[UILabel alloc] initWithFrame:CGRectMake(addImageLab.right, self.suggestionTextView.bottom + 20, 100 , 30)];
    imageCountLB.text = @"(最多5张)";
    imageCountLB.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:imageCountLB];
    
    AddImageView *view = [[AddImageView alloc] initWithFrame:CGRectMake(0, addImageLab.bottom + 10, DEF_SCREEN_WIDTH, 100 + 10)];
    view.delegate = self;
    [self.view addSubview:view];
    self.addImageView = view;
    
    UIButton *commitButton = [[UIButton alloc] initForAutoLayout];
    [self.view addSubview:commitButton];
    [commitButton setBackgroundImage:[UIImage imageNamed:@"commit"] forState:UIControlStateNormal];
    [commitButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [commitButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:view withOffset:10];
    [commitButton autoSetDimensionsToSize:CGSizeMake(225, 44)];
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];

}

- (void)commit
{
    
}

#pragma mark - AddImageViewDelegate
- (void)addImageView:(AddImageView *)addImageView didSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)addImageView:(AddImageView *)addImageView didDeleteAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didClickAddButton
{
    [self.view endEditing:YES];
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
            //选择图片
            WMPhotoPickerController *wmVC = [[WMPhotoPickerController alloc] init];
            wmVC.delegate = self;
            wmVC.selectedCount = self.savedModelArray.count;
            wmVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:wmVC animated:YES];
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - WMPhotoPickerDelegate
- (void)getPhoto:(NSArray *)imageArray
{
    for (NSDictionary *dict in imageArray)
    {
        if (self.savedModelArray.count < 5)
        {
            ImageModel *model = [[ImageModel alloc] init];
            model.image = dict[@"img"];
            [self.savedModelArray addObject:model];
        }
        [self.addImageView setModelArray:self.savedModelArray];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
//    PhotoEditorViewController *editor = [[PhotoEditorViewController alloc] init];
//    [picker pushViewController:editor animated:YES];
//    editor.image = image;
//    
//    editor.imageBlock = ^(UIImage *image){
//        
//        NSString *imageName = [CXDataBaseUtil imageName];
//        //其中参数0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
//        if ( [UIImageJPEGRepresentation(image, 0.5) writeToFile:[CXDataBaseUtil imagePathForName:imageName]  atomically:YES])
//        {
//            MeasureResult *res = [self exsistMeasureResultForIndexPath:_indexPath];
//            if (res.measurePhoto.length != 0)
//            {
//                [[NSFileManager defaultManager] removeItemAtPath:[CXDataBaseUtil imagePathForName:res.measurePhoto] error:nil];
//                NSLog(@"移除旧照片");
//            }
//            res.measurePhoto = imageName;
//            [MeasureResult insertNewMeasureResult:res];
//            [SVProgressHUD showSuccessWithStatus:@"照片保存成功"];
//        }
    
        [picker dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            // 改变状态栏的颜色  改变为白色
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    };

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
