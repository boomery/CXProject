//
//  InputView.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/13.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "InputView.h"

@implementation InputView

- (void)setUpViewsWithMeasurePoint:(NSInteger)measurePoint//每一组测量值有几个点
                        haveDesign:(BOOL)haveDesign//是否有设计值
                        designName:(NSArray *)designName//测量值名称数组，元素个数与测量值组数相同
{
    [self removeAllSubviews];
    
    UITextField *measureTextField = [self textFieldEditable:NO text:@"测量值"];
    [self addSubview:measureTextField];
    [measureTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
    [measureTextField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
    [measureTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
    [measureTextField autoSetDimension:ALDimensionHeight toSize:40];
    
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
        [views addObject:text];
        [self addSubview:text];
        [text autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:measureTextField];
        if (i == measureGroup*measurePoint - 1)
        {
            [views autoSetViewsDimension:ALDimensionHeight toSize:40];
            [views autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:5.0 insetSpacing:YES matchedSizes:YES];
        }
    }
    //设计值与设计值输入框
    if (haveDesign)
    {
        UITextField *desginTextField = [self textFieldEditable:NO text:@"设计值"];
        [self addSubview:desginTextField];
        [desginTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
        [desginTextField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
        [desginTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:measureTextField withOffset:40];
        [desginTextField autoSetDimension:ALDimensionHeight toSize:40];
        
        NSMutableArray *subViews = [[NSMutableArray alloc] init];
        for (int i = 0; i < designName.count; i ++)
        {
            UILabel *label = [[UILabel alloc] initForAutoLayout];
            [subViews addObject:label];
            [self addSubview:label];
            label.font = [UIFont systemFontOfSize:13];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = designName[i];
            [label autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:measureTextField withOffset:80];

            UITextField *text = [self textFieldEditable:YES text:@""];
            [subViews addObject:text];
            [self addSubview:text];
            [text autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:measureTextField withOffset:80];
            if (i == designName.count - 1)
            {
                [subViews autoSetViewsDimension:ALDimensionHeight toSize:40];
                [subViews autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:5.0 insetSpacing:YES matchedSizes:YES];
            }
        }
    }
    UIButton *saveButton = [[UIButton alloc] initForAutoLayout];
    [self addSubview:saveButton];
    [saveButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-59];
    [saveButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [saveButton autoSetDimensionsToSize:CGSizeMake(60, 40)];
    
    
    saveButton.layer.cornerRadius = 10;
    saveButton.clipsToBounds = YES;
    saveButton.backgroundColor = [UIColor colorWithRed:0.84 green:0.35 blue:0.29 alpha:1.00];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)save
{
    self.saveBlock();
}

- (UITextField *)textFieldEditable:(BOOL)editable  text:(NSString *)text
{
    UITextField *textField = [[UITextField alloc] initForAutoLayout];
    textField.enabled = editable;
    textField.font = [UIFont systemFontOfSize:13];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.returnKeyType = UIReturnKeyDone;
    
    textField.text = text;
    return textField;
}
@end
