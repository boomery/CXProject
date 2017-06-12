//
//  DetailMeasureViewController.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/10.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "DetailMeasureViewController.h"
#import "LabelCell.h"
#import "InputView.h"
#import "MeasureResult+Addtion.h"
#import "BridgeUtil.h"
#import <Photos/Photos.h>
#import "PhotoEditorViewController.h"
#import "CXDataBaseUtil.h"
#import "NSString+isValid.h"
#import "DetailMeasureCell.h"
@interface DetailMeasureViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, InputViewDelegate>
{
    NSArray *_titleArray;
    __weak IBOutlet UITextField *_standardTextField;
    InputView *_inputView;
    //一个分项的录入点数组
    NSDictionary *_resultsDict;
    
    UITextField *_activeTextField;
    //拍照相关变量
    BOOL _showPhoto;
    UIImageView *_imageView;
    UIView *_backView;
}
//记录选中的行与点
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *measureArea;
@property (weak, nonatomic) IBOutlet UITextField *measurePoint;
@end

@implementation DetailMeasureViewController

- (void)dealloc
{
    [MHKeyboard removeRegisterTheViewNeedMHKeyboard];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MHKeyboard addRegisterTheViewNeedMHKeyboard:self.view];
}

static NSString *labelCellIdentifier = @"LabelCell";
static NSString *detailMeasureCellIdentifier = @"DetailMeasureCell";
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
    [self initData];
    [self.tableView selectRowAtIndexPath:_indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self setUpInputViewsWithIndex:0];
    [self setViews];
}

- (void)initData
{
    _indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self loadMeasureResults];
    [self updateQualified];
}

- (void)initViews
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"拍照" style:UIBarButtonItemStylePlain target:self action:@selector(takePhoto)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"查看" style:UIBarButtonItemStylePlain target:self action:@selector(viewPhoto)];

    self.navigationItem.rightBarButtonItems = @[item, item2];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"LabelCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:labelCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailMeasureCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:detailMeasureCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.collectionView.layer.borderWidth = 0.3;
    self.collectionView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.tableView.layer.borderWidth = 0.3;
    self.tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _standardTextField.layer.borderWidth = 0.3;
    _standardTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    InputView *view = [[InputView alloc] initForAutoLayout];
    view.delegate = self;
    _inputView = view;
    [self.view addSubview:view];
    [view autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.tableView];
    [view autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_standardTextField];
    [view autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    
    __weak typeof(self) weakSelf = self;;
    _inputView.saveBlock = ^{
        MeasureResult *result = [weakSelf exsistMeasureResultForIndexPath:weakSelf.indexPath];
        if (result.measurePlace.length == 0)
        {
            [weakSelf saveHaveMeasurePlace:@""];
        }
        else
        {
            [weakSelf saveHaveMeasurePlace:result.measurePlace];
        }
    };
    _inputView.deleteBlock = ^{
        if ([weakSelf exsistMeasureResultForIndexPath:weakSelf.indexPath])
        {
            [weakSelf deleteMeasureResult];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"该点无数据"];
        }
    };
    _inputView.showBlock = ^{
        if ([weakSelf exsistMeasureResultForIndexPath:weakSelf.indexPath])
        {
            [weakSelf showPlace];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"请先保存录入数据后再输入地点"];
        }
    };
}

- (void)takePhoto
{
    if (![self exsistMeasureResultForIndexPath:_indexPath])
    {
        [SVProgressHUD showErrorWithStatus:@"请先保存录入数据后再拍照"];
        return;
    }
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
    MeasureResult *res = [self exsistMeasureResultForIndexPath:_indexPath];
    if (res.measurePhoto.length != 0)
    {
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
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.view addSubview:imageView];
            _imageView = imageView;
            [imageView autoCenterInSuperview];
            [imageView autoSetDimensionsToSize:CGSizeMake(300, 300)];
            imageView.image = [UIImage imageWithContentsOfFile:[CXDataBaseUtil imagePathForName:res.measurePhoto]];
            _showPhoto = !_showPhoto;
        }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"请先拍照后查看"];
    }
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    _showPhoto = NO;
    [_imageView removeFromSuperview];
    [tap.view removeFromSuperview];
}

#pragma mark - 根据不同情况返回数字
- (NSInteger)countedNumberForOrignalNumber:(NSInteger)orignalNumber
{
    NSInteger countedNum = 0;
    if ([self isSpecial])
    {
        countedNum = orignalNumber/5;
    }
    else if ([self haveMoreThanTwoDesign])
    {
        countedNum = orignalNumber/2;
    }
    else
    {
        countedNum = orignalNumber;
    }
    return countedNum;
}

#pragma mark - InputViewDelegate
- (void)lastTextFieldWillReturn
{
    MeasureResult *result = [self exsistMeasureResultForIndexPath:self.indexPath];
    if (result.measurePlace.length == 0)
    {
        [self saveHaveMeasurePlace:@""];
    }
    else
    {
        [self saveHaveMeasurePlace:result.measurePlace];
    }
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
        if ([CXDataBaseUtil saveImage:image withRatio:0.5 imageName:imageName])
        {
            MeasureResult *res = [self exsistMeasureResultForIndexPath:_indexPath];
            if (res.measurePhoto.length != 0)
            {
                [[NSFileManager defaultManager] removeItemAtPath:[CXDataBaseUtil imagePathForName:res.measurePhoto] error:nil];
                NSLog(@"移除旧照片");
            }
            res.measurePhoto = imageName;
            [MeasureResult insertNewMeasureResult:res];
            [SVProgressHUD showSuccessWithStatus:@"照片保存成功"];
        }
        [picker dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            // 改变状态栏的颜色  改变为白色
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    };
}

#pragma mark - 为右侧录入视图控件布局
- (void)setUpInputViewsWithIndex:(NSInteger)index
{
    if (_event.events.count > index)
    {
        Event *subEvent = _event.events[index];
        //有文字标准的情况
        if (subEvent.textStandard)
        {
            _standardTextField.text = subEvent.textStandard;
        }
        //数字标准
        else
        {
            NSNumberFormatter *fo = [[NSNumberFormatter alloc] init];
            fo.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *minNum = [NSNumber numberWithFloat:subEvent.min];
            NSNumber *maxNum = [NSNumber numberWithFloat:subEvent.max];
            
            NSString *min = [fo stringFromNumber:minNum];
            NSString *max = [fo stringFromNumber:maxNum];
            _standardTextField.text = [NSString stringWithFormat:@"{%@~%@}mm",min,max];
        }
        [_inputView setUpViewsWithMeasurePoint:subEvent.measurePoint haveDesign:subEvent.needDesgin designName:subEvent.designName];
    }
}

#pragma mark - 从数据库查询本地分项录入点记录
- (void)loadMeasureResults
{
    if (_event.events.count > 0)
    {
        Event *subEvent = _event.events[_indexPath.section];
        NSMutableDictionary *resultsDict = [MeasureResult resultsForProjectID:[User editingProject].fileName itemName:_event.name subItemName:subEvent.name];
        _resultsDict = resultsDict;
        [self.collectionView reloadData];
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

- (BOOL)isValidInput
{
    if (_measureArea.text.length == 0 || _measurePoint.text.length == 0 || ![_inputView haveSetValue])
    {
        [SVProgressHUD showErrorWithStatus:@"请填写正确完整的数据，可以使用小数点 '.' 作为占位符"];
        return NO;
    }
    Event *subEvent = _event.events[_indexPath.section];
    if ([subEvent.method isEqualToString:@"5"])
    {
        if (!([_inputView.measureValues isEqualToString:@"1"] || [_inputView.measureValues isEqualToString:@"0"]))
        {
            [SVProgressHUD showErrorWithStatus:@"请直接输入1或0"];
            return NO;
        }
    }
    return YES;
}

#pragma mark - 录入点保存到本地
- (void)saveHaveMeasurePlace:(NSString *)measurePlace
{
    if ([self isValidInput])
    {
        Event *subEvent = _event.events[_indexPath.section];
        MeasureResult *result = [self exsistMeasureResultForIndexPath:_indexPath];
        if (!result)
        {
            result = [[MeasureResult alloc] init];
            result.measurePhoto = @"";
        }
        result.projectID = [User editingProject].fileName;
        result.itemName = _event.name;
        result.subItemName = subEvent.name;
        if (![result.measureArea isEqualToString:_measureArea.text] || ![result.measurePoint isEqualToString:_measurePoint.text])
        {
            result.measureArea = _measureArea.text;
            result.measurePoint = _measurePoint.text;
            [MeasureResult updateMeasureAreaMeasurePointDesignValuesWithMeasureResult:result];
        }
        result.measureValues = _inputView.measureValues;
        
        result.designValues = _inputView.designValues;
        //根据算法得出结果
        NSString *countResult = [BridgeUtil resultForMeasureValues:result.measureValues designValues:result.designValues event:subEvent];
        result.measureResult = countResult;
        result.measurePlace = measurePlace;
        
        NSInteger index = [self countedNumberForOrignalNumber:_indexPath.row];
        
        result.mesaureIndex = [NSString stringWithFormat:@"%ld",index];
        
        //插入数据库
        [MeasureResult insertNewMeasureResult:result];
        
        //保存总的结果点数
        [self saveDesignNum];
        
        [_resultsDict setValue:result forKey:[NSString stringWithFormat:@"%ld",index]];
        [self reloadData];
    }
}

- (void)reloadData
{
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_indexPath.section inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    if (_event.events.count > 0)
    {
        Event *subEvent = _event.events[_indexPath.section];
        NSMutableDictionary *resultsDict = [MeasureResult resultsForProjectID:[User editingProject].fileName itemName:_event.name subItemName:subEvent.name];
        _resultsDict = resultsDict;
        
        if ([_resultsDict allValues].count == 0)
        {
            _indexPath = [NSIndexPath indexPathForRow:0 inSection:_indexPath.section];
            [self loadMeasureResults];
            [self clearMeasureAreaAndPoint];
            [self setViews];
            return;
        }
        
        [self.collectionView reloadData];
        
        NSInteger nowRow = [self countedNumberForOrignalNumber:_indexPath.row];
        
        NSInteger nextRow = nowRow + 1;
        
        
        NSInteger measureNum = [self isSpecial] ? [_measurePoint.text integerValue] : [_measureArea.text integerValue];
        if ([self haveMoreThanTwoDesign])
        {
            measureNum = measureNum * 2;
        }
        
        NSInteger countedNextRow = nextRow;
        if ([self isSpecial])
        {
            countedNextRow = nextRow*5;
        }
        else if ([self haveMoreThanTwoDesign])
        {
            countedNextRow = nextRow*2;
        }
        
        if (measureNum > countedNextRow)
        {
            _indexPath = [NSIndexPath indexPathForRow:countedNextRow inSection:_indexPath.section];
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:countedNextRow inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            [self setViews];
            [_inputView beinEditing];
        }
        else
        {
            _indexPath = [NSIndexPath indexPathForRow:_indexPath.row inSection:_indexPath.section];
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:_indexPath.row inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            [SVProgressHUD showSuccessWithStatus:@"本项数据录入完成"];
            [self.view endEditing:YES];
        }
        [self updateQualified];
    }
}

#pragma mark - 删除结果点
- (void)deleteMeasureResult
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要删除这组数据吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入密码";
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if ([[alert.textFields[0] text] isEqualToString:@"admin"])
        {
            [MeasureResult deleteMeasureResult:[self exsistMeasureResultForIndexPath:_indexPath]];
            [self reloadData];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"密码错误"];
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 保存设计总点数
- (void)saveDesignNum
{
    Event *subEvent = _event.events[_indexPath.section];
    
    NSInteger num = 0;
    if ([self isSpecial])
    {
        num = [_measurePoint.text integerValue];
        
    }
    else
    {
        num = [_measureArea.text integerValue];
    }
    if ([self haveMoreThanTwoDesign])
    {
        num = num * 2;
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:num forKey:DESIGN_NUM_KEY([User editingProject].fileName, _event.name, subEvent.name)];
}

- (void)updateQualified
{
    Event *subEvent = _event.events[_indexPath.section];
    NSInteger results = [MeasureResult numOfResultsForProjectID:[User editingProject].fileName itemName:_event.name subItemName:subEvent.name];
    NSInteger qualified = [MeasureResult numOfQualifiedForProjectID:[User editingProject].fileName itemName:_event.name subItemName:subEvent.name];
    if (results == 0)
    {
        self.title = @"合格率";
    }
    else
    {
        self.title = [NSString stringWithFormat:@"合格率:%.0f%%", (float)qualified/results*100];
    }
}


#pragma mark - 是否是算法三或八的数据
- (BOOL)isSpecial
{
    Event *subEvent = _event.events[_indexPath.section];
    if ([subEvent.method isEqualToString:@"3"] || [subEvent.method isEqualToString:@"8"])
        return YES;
    else
        return NO;
}

- (BOOL)haveMoreThanTwoDesign
{
    Event *subEvent = _event.events[_indexPath.section];
    if (subEvent.designName.count > 1)
    {
        return YES;
    }
    return NO;
}

#pragma mark - 判断数据记录是否存在
- (MeasureResult *)exsistMeasureResultForIndexPath:(NSIndexPath *)indexPath
{
    return _resultsDict[[NSString stringWithFormat:@"%ld",[self countedNumberForOrignalNumber:indexPath.row]]];
}

#pragma mark - 选择大项分项时执行记录是否存在的判断 若存在则赋值
- (void)setViews
{
    [self clearMeasureValues];
    MeasureResult *res = [self exsistMeasureResultForIndexPath:_indexPath];
    if (res)
    {
        [self setValueWithResult:res];
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:@"无数据记录"];
    }
}

- (void)setValueWithResult:(MeasureResult *)result
{
    _measureArea.text = result.measureArea;
    _measurePoint.text = result.measurePoint;
    [_inputView setMeasureValues:result.measureValues];
    [_inputView setDesignValues:result.designValues];
}

#pragma mark - 清空录入框
- (void)clearMeasureValues
{
    [_inputView setMeasureValues:@""];
}

- (void)clearMeasureAreaAndPoint
{
    _measureArea.text = @"";
    _measurePoint.text = @"";
}

#pragma mark - 点击地点显示弹框
- (void)showPlace
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"录入点位置" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        MeasureResult *res = [self exsistMeasureResultForIndexPath:_indexPath];
        textField.text = res.measurePlace;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self saveHaveMeasurePlace:alert.textFields[0].text];
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 50;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:labelCellIdentifier forIndexPath:indexPath];
    UIView *selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView = selectedBackgroundView;
    selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
    cell.itemLabel.text = @"";
    
    NSInteger measureNum = [self isSpecial] ? [_measurePoint.text integerValue] : [_measureArea.text integerValue];
    if ([self haveMoreThanTwoDesign])
    {
        measureNum = [_measureArea.text integerValue] * 2;
    }
    if (measureNum > indexPath.row)
    {
        cell.backgroundColor = [UIColor whiteColor];
        cell.userInteractionEnabled = YES;
    }
    else
    {
        cell.backgroundColor = [UIColor grayColor];
        cell.userInteractionEnabled = NO;
    }
    
    MeasureResult *res = [self exsistMeasureResultForIndexPath:indexPath];
    if (res)
    {
        NSArray *results = [res.measureResult componentsSeparatedByString:@";"];
        if (results.count > 1)
        {
            if ([self haveMoreThanTwoDesign])
            {
                Event *subEvent = _event.events[_indexPath.section];
                if (indexPath.row%2 == 0)
                {
                    cell.itemLabel.text = subEvent.designName[0];

                }
                else
                {
                    cell.itemLabel.text = subEvent.designName[1];
                }
                cell.label.text = results[indexPath.row%2];
            }
            else
            {
                cell.label.text = results[indexPath.row%5];
            }
        }
        else
        {
            cell.label.text = res.measureResult;
        }
        
        if ([cell.label.text isEqualToString:@"1"])
        {
            selectedBackgroundView.backgroundColor = [UIColor purpleColor];
            cell.backgroundColor = [UIColor colorWithRed:0.84 green:0.35 blue:0.29 alpha:1.00];
        }
    }
    else
    {
        cell.label.text = @"-";
    }
    return cell;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    _indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:_indexPath.section];
    [self setViews];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _event.events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailMeasureCell *cell = [tableView dequeueReusableCellWithIdentifier:detailMeasureCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = LABEL_FONT;
    cell.textLabel.numberOfLines = 0;
    Event *event = _event.events[indexPath.row];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.nameLabel.text = event.name;
    cell.progressLabel.text = [NSString stringWithFormat:@"%ld/%ld",[MeasureResult numOfResultsForProjectID:[User editingProject].fileName itemName:_event.name subItemName:event.name], [MeasureResult numOfDesignResultsForProjectID:[User editingProject].fileName itemName:_event.name subItemName:event.name]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    _indexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
    [self setUpInputViewsWithIndex:_indexPath.section];
    [self loadMeasureResults];
    [self clearMeasureAreaAndPoint];
    [self setViews];
    [self updateQualified];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event *event = _event.events[indexPath.row];
    NSDictionary *attribute = @{NSFontAttributeName:LABEL_FONT};
    CGSize size = [event.name boundingRectWithSize:CGSizeMake(DEF_SCREEN_WIDTH*0.25 , MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size.height + 50 + 40;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_activeTextField == _measureArea)
    {
        [_measurePoint becomeFirstResponder];
    }
    else
    {
        [_inputView beinEditing];
    }
    return YES;
}

//控制检测区与检测点的录入字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length > 0 && ![string isValidInt])
    {
        [SVProgressHUD showInfoWithStatus:@"请输入正整数"];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _standardTextField)
    {
        ALERT(textField.text);
        return NO;
    }
    _activeTextField = textField;
    textField.inputAccessoryView = [self toolbar];
    return YES;
}

- (UIToolbar *)toolbar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 50)];
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithTitle:@"下一项" style:UIBarButtonItemStyleDone target:self action:@selector(textFieldShouldReturn:)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    NSArray *itemArrat = [[NSArray alloc] initWithObjects:spaceItem, spaceItem, spaceItem, nextItem, nil];
    toolbar.items = itemArrat;
    return toolbar;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
