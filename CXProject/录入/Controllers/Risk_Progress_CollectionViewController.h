//
//  Risk_Progress_CollectionViewController.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/5.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "BaseViewController.h"

@interface Risk_Progress_CollectionViewController : BaseViewController

//照片一级分类
@property (nonatomic, assign) NSInteger index;
//数据源数组
@property (nonatomic, strong) NSArray *sourceArray;
//是否显示未分类文件夹
@property (nonatomic, assign) BOOL showUnsorted;
//collectionView高度
@property (nonatomic, assign) BOOL isShort;
@end
