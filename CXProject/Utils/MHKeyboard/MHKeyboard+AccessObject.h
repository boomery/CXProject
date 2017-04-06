//
//  MHKeyboard+AccessObject.h
//  MHProject
//
//  Created by Andy on 15/5/13.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "MHKeyboard.h"
#import <objc/runtime.h>
#import "MHKeyboardObjects.h"

@interface MHKeyboard (AccessObject)

+ (MHKeyboardObjects *)objects;

@end
