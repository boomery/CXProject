//
//  InputView.m
//  CXProject
//
//  Created by zhangchaoxin on 2017/4/13.
//  Copyright © 2017年 zhangchaoxin. All rights reserved.
//

#import "InputView.h"

@implementation InputView

- (void)setUpViewsWithMeasureGroup:(NSInteger)group//几组测量值
                      MeasurePoint:(NSInteger)measurePoint//每一组测量值有几个点
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
    
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (int i = 0; i < measurePoint; i ++)
    {
        UITextField *text = [self textFieldEditable:YES text:@""];
        [views addObject:text];
        [self addSubview:text];
        [text autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:measureTextField];
    }
    
    [views autoSetViewsDimension:ALDimensionHeight toSize:40];
    [views autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:5.0 insetSpacing:YES matchedSizes:YES];
    
    if (haveDesign)
    {
        UITextField *desginTextField = [self textFieldEditable:NO text:@"设计值"];
        [self addSubview:desginTextField];
        [desginTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
        [desginTextField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
        [desginTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:measureTextField withOffset:40];
        [desginTextField autoSetDimension:ALDimensionHeight toSize:40];
        
//        for (NSString *designName in <#collection#>) {
//            <#statements#>
//        }
    }
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
