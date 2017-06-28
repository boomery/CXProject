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
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    self.navigationController.navigationBar.shadowImage = nil;
    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
    
    self.savedModelArray = [[NSMutableArray alloc] init];
    
    self.suggestionTextView = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(0, 64, DEF_SCREEN_WIDTH, 130/568.0 * DEF_SCREEN_HEIGHT)];
    self.suggestionTextView.scrollEnabled = YES;
    self.suggestionTextView.font        = [UIFont systemFontOfSize:13.5];
    self.suggestionTextView.textColor   = [UIColor blackColor];
    self.suggestionTextView.placeholder =@"请输入遇到的问题或建议...";
    self.suggestionTextView.placeholderColor = [UIColor grayColor];
    self.suggestionTextView.delegate    = self;
    self.suggestionTextView.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:self.suggestionTextView];
    
    UILabel *addImageLab= [[UILabel alloc] initWithFrame:CGRectMake(20, self.suggestionTextView.bottom + 20, 95, 30)];
    addImageLab.text = @"添加图片说明";
    addImageLab.font = [UIFont systemFontOfSize:13.5];
    [self.view addSubview:addImageLab];
    UILabel *imageCountLB= [[UILabel alloc] initWithFrame:CGRectMake(addImageLab.right, self.suggestionTextView.bottom + 20, 100, 30)];
    imageCountLB.text = @"(最多5张)";
    imageCountLB.textColor = [UIColor grayColor];
    imageCountLB.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:imageCountLB];
    
    AddImageView *view = [[AddImageView alloc] initWithFrame:CGRectMake(0, addImageLab.bottom + 10, DEF_SCREEN_WIDTH, 100 + 10)];
    view.delegate = self;
    [self.view addSubview:view];
    self.addImageView = view;
    
    UIButton *commitButton = [[UIButton alloc] initForAutoLayout];
    [self.view addSubview:commitButton];
    commitButton.backgroundColor = [UIColor colorWithRed:0.84 green:0.20 blue:0.15 alpha:1.00];
    commitButton.layer.cornerRadius = 10;
    commitButton.clipsToBounds = YES;
    [commitButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [commitButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:view withOffset:40];
    [commitButton autoSetDimensionsToSize:CGSizeMake(DEF_SCREEN_WIDTH - 40, 44)];
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
    if (self.savedModelArray.count < 5)
    {
        ImageModel *model = [[ImageModel alloc] init];
        model.image = image;
        [self.savedModelArray addObject:model];
    }
    [self.addImageView setModelArray:self.savedModelArray];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        // 改变状态栏的颜色  改变为白色
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
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
