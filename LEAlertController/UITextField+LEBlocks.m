//
//  UITextField+LEBlocks.m
//  LEAlertControllerDemo
//
//  Created by Vlad Getman on 02.09.15.
//  Copyright (c) 2015 Lasha Efremidze. All rights reserved.
//

#import "UITextField+LEBlocks.h"

#import <objc/runtime.h>

static char UITextFieldDidChangeBlockKey;

@implementation UITextField (LEBlocks)

- (TextFieldBlock)didChangeBlock
{
    return objc_getAssociatedObject(self, &UITextFieldDidChangeBlockKey);
}

- (void)setDidChangeBlock:(TextFieldBlock)didChangeBlock
{
    [self addTarget:self
             action:@selector(textFieldDidChangeEditing:)
   forControlEvents:UIControlEventEditingChanged];
    objc_setAssociatedObject(self, &UITextFieldDidChangeBlockKey, didChangeBlock, OBJC_ASSOCIATION_COPY);
}

- (void)textFieldDidChangeEditing:(UITextField *)textField {
    if (self.didChangeBlock)
        self.didChangeBlock(textField);
}

@end
