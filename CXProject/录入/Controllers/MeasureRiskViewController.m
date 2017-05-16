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
#import "RiskResult+Addition.h"
@interface MeasureRiskViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    IBOutlet UIScrollView *_contentScrollView;
    __weak IBOutlet UILabel *_positionLabel;
    __weak IBOutlet UILabel *_responsibilityLabel;
    
    IBOutletCollection(UIButton) NSArray *_scoreArray;
    
    IBOutletCollection(UIButton) NSArray *_levelArray;
    
    __weak IBOutlet UILabel *_resultLabel;
    
    IBOutletCollection(UIButton) NSArray *_responsibilityArray;
    
    //拍照相关变量
    BOOL _showPhoto;
    UIImageView *_imageView;
    UIView *_backView;
    
    //数据源
    RiskResult *_riskResult;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation MeasureRiskViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
    [self loadRiskResults];
    [self setViews];
}

- (void)initViews
{
    _contentScrollView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH , DEF_SCREEN_HEIGHT);
   
    [self.view addSubview:_contentScrollView];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
    _positionLabel.text = _position;
    
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photoButton.frame = CGRectMake(0, 0, 15*1.14, 15);
    [photoButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    [photoButton setBackgroundImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:photoButton];
    self.navigationItem.rightBarButtonItem = item;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _responsibilityLabel.bottom + 10, DEF_SCREEN_WIDTH, 100) collectionViewLayout:layout];
    [_contentScrollView addSubview:self.collectionView];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor redColor];
    self.collectionView.clipsToBounds = NO;
//    self.collectionView.delegate = self;
//    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"tribeMember"];
    
    UIButton *saveButton = [[UIButton alloc] initForAutoLayout];
    
    saveButton.backgroundColor = [UIColor colorWithRed:0.27 green:0.63 blue:0.96 alpha:1.00];
    [_contentScrollView addSubview:saveButton];
    [saveButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_collectionView withOffset:10];
    [saveButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [saveButton autoSetDimensionsToSize:CGSizeMake(100, 44)];
    [saveButton setTitle:@"确认" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
     _contentScrollView.contentSize = CGSizeMake(DEF_SCREEN_WIDTH - 10, 50*13 + 64 + _collectionView.height + 44 + 30);
}

#pragma mark - 读取本地记录
- (void)loadRiskResults
{
    RiskResult *result = [RiskResult resultForProjectID:[User editingProject].fileName itemName:_position subItemName:nil];
    if (!result)
    {
        result = [[RiskResult alloc] init];
        result.score = @"0";
        result.level = @"0";
        result.result = @"95";
        result.responsibility = @"0";
    }
    _riskResult = result;
}

#pragma mark - 控件赋值
- (void)setViews
{
    
}

#pragma mark - 选择分数档次
- (IBAction)scoreButtonClick:(UIButton *)sender
{
    UIButton *selectedButton = _scoreArray[[_riskResult.score integerValue]];
    if (sender != selectedButton)
    {
        selectedButton.selected = NO;
        sender.selected = YES;
        _riskResult.score = [NSString stringWithFormat:@"%ld",(long)sender.tag];
        [self updateResult];
    }
}

#pragma mark - 显示评分规则
- (IBAction)textStandardButtonClick:(UIButton *)sender
{
    
}

#pragma mark - 选择整改难易度
- (IBAction)levelButtonClick:(UIButton *)sender
{
    UIButton *selectedButton = _levelArray[[_riskResult.level integerValue]];
    if (sender != selectedButton)
    {
        selectedButton.selected = NO;
        sender.selected = YES;
        _riskResult.level = [NSString stringWithFormat:@"%ld",(long)sender.tag];
        [self updateResult];
    }
}

#pragma mark - 选择责任单位
- (IBAction)responsibilityButtonClick:(UIButton *)sender
{
    UIButton *selectedButton = _responsibilityArray[[_riskResult.responsibility integerValue]];
    if (sender != selectedButton)
    {
        selectedButton.selected = NO;
        sender.selected = YES;
        _riskResult.responsibility = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    }
}

#pragma mark - 更新结算分数
- (void)updateResult
{
    NSInteger result = (5 - [_riskResult.score integerValue]) * 20 - 5 - ([_riskResult.level integerValue] * 10);
    _resultLabel.text = [NSString stringWithFormat:@"%ld",(long)result];
}
#pragma mark - 记录保存到本地
- (void)saveButtonClick
{
    
}

#pragma mark - 拍摄照片
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
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusNotDetermined){
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

#pragma mark - 查看照片
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
