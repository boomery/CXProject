//
//  ManagementViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/14.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "ManagementViewController.h"
#import "Management_ViewController.h"
#import <Photos/Photos.h>
#import "Management_PhotoEditorViewController.h"
#import "FileManager.h"
@interface ManagementViewController ()<ViewPagerDelegate, ViewPagerDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *controllerArray;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation ManagementViewController
static NSString *fileCellIdentifier = @"FileCell";
static NSString *headerIdentifier = @"sectionHeader";

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initViews];
}

- (void)initData
{
    self.dataSource = self;
    self.delegate = self;
    self.controllerArray = [[NSMutableArray alloc] init];
    NSArray *array = [DataProvider riskProgressItems];
    for (Event *event in array)
    {
        if ([event.name isEqualToString:@"管理行为"])
        {
            _titleArray = event.events;
            for (Event *subEvent in event.events)
            {
                Management_ViewController *c = [[Management_ViewController alloc] init];
                c.view.backgroundColor = [UIColor clearColor];
                c.event = subEvent;
                c.sourceArray = subEvent.events;
                [self.controllerArray addObject:c];
            }
        }
    }
}

- (void)initViews
{
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
    self.extendedLayoutIncludesOpaqueBars = YES;

    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photoButton.frame = CGRectMake(0, 0, 15*1.14, 15);
    [photoButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    [photoButton setBackgroundImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:photoButton];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark - 拍摄照片
- (void)takePhoto
{
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

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    Management_PhotoEditorViewController *editor = [[Management_PhotoEditorViewController alloc] init];
    [picker pushViewController:editor animated:YES];
    Event *subEvent = _titleArray[self.activeTabIndex];
    editor.kindName = subEvent.name;
    editor.image = image;
    editor.imageBlock = ^(Photo *photo){
        //其中参数0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
        if ([FileManager savePhoto:photo])
        {
            [Photo insertNewPhoto:photo];
            [SVProgressHUD showSuccessWithStatus:@"照片保存成功"];
        }
        [picker dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            // 改变状态栏的颜色  改变为白色
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    };
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager
{
    return _titleArray.count;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index
{
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.0];
    Event *subEvent = _titleArray[index];
    label.text = [NSString stringWithFormat:@"%@", subEvent.name];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index
{
    return _controllerArray[index];
}

#pragma mark - ViewPagerDelegate
- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index
{
    
}

- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value
{
    switch (option) {
        case ViewPagerOptionTabWidth:
            return DEF_SCREEN_WIDTH/3.0;
            break;
        default:
            break;
    }
    
    return value;
}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color
{
    switch (component) {
        case ViewPagerIndicator:
            return [UIColor colorWithRed:0.92 green:0.20 blue:0.15 alpha:1.00];
            break;
        case ViewPagerTabsView:
            return [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
            break;
        default:
            break;
    }
    return color;
}

@end
