//
//  Risk_Progress_CollectionViewController.h
//  CXProject
//
//  Created by zhangchaoxin on 2017/6/5.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "BaseViewController.h"

@interface Risk_Progress_CollectionViewController : BaseViewController

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSArray *sourceArray;
//是否显示未分类文件夹
@property (nonatomic, assign) BOOL showUnsorted;
//collectionView高度
@property (nonatomic, assign) BOOL isShort;
@end
