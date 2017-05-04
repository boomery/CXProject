//
//  InputView.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/13.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "InputView.h"
#import "NSString+isValid.h"
@interface InputView () <UITextFieldDelegate>
{
    NSMutableArray *_measureTextfieldArray;
    NSMutableArray *_designTextfieldArray;
}
@end
@implementation InputView

- (void)setUpViewsWithMeasurePoint:(NSInteger)measurePoint//每一组测量值有几个点
                        haveDesign:(BOOL)haveDesign//是否有设计值
                        designName:(NSArray *)designName//测量值名称数组，元素个数与测量值组数相同
{
//    BOOL is5 = IS_IPHONE_5;
    CGFloat height = 40;
    
    _measureTextfieldArray = [[NSMutableArray alloc] init];
    _designTextfieldArray = [[NSMutableArray alloc] init];
    [self removeAllSubviews];
    
    UITextField *measureTextField = [self textFieldEditable:NO text:@"测量值"];
    [self addSubview:measureTextField];
    [measureTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
    [measureTextField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
    [measureTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
    [measureTextField autoSetDimension:ALDimensionHeight toSize:height];
    
    NSInteger measureGroup = designName.count;
    if (measureGroup == 0)
    {
        //最少要有一组测量值
        measureGroup = 1;
    }
    //测量值输入框
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (int i = 0; i < measureGroup*measurePoint; i ++)
    {
        UITextField *text = [self textFieldEditable:YES text:@""];
        [_measureTextfieldArray addObject:text];
        [views addObject:text];
        [self addSubview:text];
        [text autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:measureTextField];
        if (i == measureGroup*measurePoint - 1)
        {
            text.returnKeyType = UIReturnKeyDone;
            [views autoSetViewsDimension:ALDimensionHeight toSize:height];
            [views autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:5.0 insetSpacing:YES matchedSizes:YES];
        }
    }
    //设计值与标签设计值输入框
    if (haveDesign)
    {
        /*设计值布局*/
        UITextField *desginTextField = [self textFieldEditable:NO text:@"设计值"];
        [self addSubview:desginTextField];
        [desginTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
        [desginTextField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
        [desginTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:measureTextField withOffset:height];
        [desginTextField autoSetDimension:ALDimensionHeight toSize:height];
        
        NSMutableArray *subViews = [[NSMutableArray alloc] init];
        for (int i = 0; i < designName.count; i ++)
        {
            UILabel *label = [[UILabel alloc] initForAutoLayout];
            [subViews addObject:label];
            [self addSubview:label];
            label.font = [UIFont systemFontOfSize:13];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = designName[i];
            [label autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:measureTextField withOffset:height*2];

            UITextField *text = [self textFieldEditable:YES text:@""];
            [subViews addObject:text];
            [_designTextfieldArray addObject:text];
            [self addSubview:text];
            [text autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:measureTextField withOffset:height*2];
            if (i == designName.count - 1)
            {
                [subViews autoSetViewsDimension:ALDimensionHeight toSize:height];
                [subViews autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:5.0 insetSpacing:YES matchedSizes:YES];
            }
        }
    }

    /*保存按钮布局*/
    UIButton *saveButton = [[UIButton alloc] initForAutoLayout];
    [self addSubview:saveButton];
    [saveButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-20];
    
    UIButton *placeButton = [[UIButton alloc] initForAutoLayout];
    [self addSubview:placeButton];
    
    NSArray *array = @[placeButton, saveButton];
    
    [array autoSetViewsDimension:ALDimensionHeight toSize:height];
    [array autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:20.0 insetSpacing:YES matchedSizes:YES];
    
    placeButton.layer.cornerRadius = 10;
    placeButton.clipsToBounds = YES;
    placeButton.backgroundColor = [UIColor colorWithRed:0.27 green:0.63 blue:0.96 alpha:1.00];
    [placeButton setTitle:@"地点" forState:UIControlStateNormal];
    [placeButton addTarget:self action:@selector(showPlace) forControlEvents:UIControlEventTouchUpInside];
    
    saveButton.layer.cornerRadius = 10;
    saveButton.clipsToBounds = YES;
    saveButton.backgroundColor = [UIColor colorWithRed:0.27 green:0.63 blue:0.96 alpha:1.00];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger index = [_measureTextfieldArray indexOfObject:textField];
    index++;
    if (_measureTextfieldArray.count > index)
    {
        UITextField *text = _measureTextfieldArray[index];
        [text becomeFirstResponder];
        NSLog(@"切换到下一个输入框");
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(lastTextFieldWillReturn)])
        {
            [self.delegate lastTextFieldWillReturn];
        }
    }
    return YES;
}

- (void)showPlace
{
    if (self.showBlock)
    {
        self.showBlock();
    }
}

- (void)save
{
    if (self.saveBlock)
    {
        self.saveBlock();
    }
}

- (UITextField *)textFieldEditable:(BOOL)editable  text:(NSString *)text
{
    UITextField *textField = [[UITextField alloc] initForAutoLayout];
    textField.enabled = editable;
    textField.delegate = self;
    textField.font = [UIFont systemFontOfSize:13];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    textField.returnKeyType = UIReturnKeyNext;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.text = text;
    return textField;
}

- (void)beinEditing
{
    if (_measureTextfieldArray.count > 0)
    {
        UITextField *text = _measureTextfieldArray[0];
        [text becomeFirstResponder];
    }
}

- (BOOL)haveSetValue
{
    for (UITextField *text in _measureTextfieldArray)
    {
        if (text.text.length == 0 || ![text.text isValidNumber])
        {
            return NO;
        }
    }
    for (UITextField *text in _designTextfieldArray)
    {
        if (text.text.length == 0 || ![text.text isValidNumber])
        {
            return NO;
        }
    }
    return YES;
}

- (void)setMeasureValues:(NSString *)measureValues
{
    if (measureValues.length == 0)
    {
        for (int i = 0; i < _measureTextfieldArray.count; i++)
        {
            UITextField *text = _measureTextfieldArray[i];
            text.text = @"";
        }
        return;
    }
    NSArray *stringArray = [measureValues componentsSeparatedByString:@";"];
    for (int i = 0; i < _measureTextfieldArray.count; i++)
    {
        UITextField *text = _measureTextfieldArray[i];
        text.text = stringArray[i];
    }
}
- (void)setDesignValues:(NSString *)designValues
{
    if (designValues.length == 0)
    {
        for (int i = 0; i < _designTextfieldArray.count; i++)
        {
            UITextField *text = _designTextfieldArray[i];
            text.text = @"";
        }
        return;
    }
    NSArray *stringArray = [designValues componentsSeparatedByString:@";"];
    for (int i = 0; i < _designTextfieldArray.count; i++)
    {
        UITextField *text = _designTextfieldArray[i];
        text.text = stringArray[i];
    }
}

//多个值用分号隔开
- (NSString *)measureValues
{
    NSString *values = @"";
    for (UITextField *text in _measureTextfieldArray)
    {
        if (text == [_measureTextfieldArray lastObject])
        {
            values = [values stringByAppendingString:[NSString stringWithFormat:@"%@",text.text]];
        }
        else
        {
            values = [values stringByAppendingString:[NSString stringWithFormat:@"%@;",text.text]];
        }
    }
    return values;
}
- (NSString *)designValues
{
    NSString *values = @"";
    for (UITextField *text in _designTextfieldArray)
    {
        if (text == [_designTextfieldArray lastObject])
        {
            values = [values stringByAppendingString:[NSString stringWithFormat:@"%@",text.text]];
        }
        else
        {
            values = [values stringByAppendingString:[NSString stringWithFormat:@"%@;",text.text]];
        }
    }
    return values;
}
@end
