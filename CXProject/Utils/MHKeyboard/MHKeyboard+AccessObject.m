//
//  MHKeyboard+AccessObject.m
//  MHProject
//
//  Created by Andy on 15/5/13.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "MHKeyboard+AccessObject.h"

@implementation MHKeyboard (AccessObject)

+ (MHKeyboardObjects *)objects
{
    if (!objc_getAssociatedObject(self, _cmd))
    {
        objc_setAssociatedObject(self, _cmd, [MHKeyboardObjects new], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return objc_getAssociatedObject(self, _cmd);
}

@end
