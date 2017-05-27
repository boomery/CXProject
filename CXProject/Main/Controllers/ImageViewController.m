//
//  ImageViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/5/27.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    self.navigationController.navigationBar.shadowImage = nil;
    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
    
    if (self.imageName)
    {
        UIImage *image = [UIImage imageNamed:self.imageName];
        CGFloat fixelW = CGImageGetWidth(image.CGImage);
        CGFloat fixelH = CGImageGetHeight(image.CGImage);
        if (IS_IPHONE_PLUS)
        {
            fixelW = fixelW/3.0;
            fixelH = fixelH/3.0;
        }
        else
        {
            fixelW = fixelW/2.0;
            fixelH = fixelH/2.0;
        }
        CGFloat scale = [[UIScreen mainScreen] bounds].size.width/fixelW;
        CGFloat scaleHeight = fixelH * scale;
        
        self.scrollView.contentSize = CGSizeMake(0, scaleHeight);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width , scaleHeight)];
        imageView.image = image;
        [self.scrollView addSubview:imageView];
    }
    // Do any additional setup after loading the view.
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
