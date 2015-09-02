//
//  UITextField+LEBlocks.m
//  LEAlertControllerDemo
//
//  Created by Vlad Getman on 02.09.15.
//  Copyright (c) 2015 Lasha Efremidze. All rights reserved.
//

#import "UITextField+LEBlocks.h"

#import <objc/runtime.h>

static char UITextFieldDelegateKey;

static char UITextFieldDidChangeBlockKey;

@interface UITextField () <UITextFieldDelegate>

@end

@implementation UITextField (LEBlocks)

- (void)checkDelegate
{
    if (self.delegate != self) {
        objc_setAssociatedObject(self, &UITextFieldDelegateKey, self.delegate, OBJC_ASSOCIATION_ASSIGN);
        self.delegate = self;
    } else {
        self.delegate = self;
    }
}

- (id<UITextFieldDelegate>)originalDelegate
{
    return objc_getAssociatedObject(self, &UITextFieldDelegateKey);
}

#pragma mark -

- (TextFieldBlock)didChangeBlock
{
    return objc_getAssociatedObject(self, &UITextFieldDidChangeBlockKey);
}

- (void)setDidChangeBlock:(TextFieldBlock)didChangeBlock
{
    [self checkDelegate];
    objc_setAssociatedObject(self, &UITextFieldDidChangeBlockKey, didChangeBlock, OBJC_ASSOCIATION_COPY);
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self addTarget:self
             action:@selector(textFieldDidChangeEditing:)
   forControlEvents:UIControlEventEditingChanged];
    
    id originalDelegate = [self originalDelegate];
    if ([originalDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)])
        [originalDelegate textFieldDidBeginEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self removeTarget:self
             action:@selector(textFieldDidChangeEditing:)
   forControlEvents:UIControlEventEditingChanged];
    
    id originalDelegate = [self originalDelegate];
    if ([originalDelegate respondsToSelector:@selector(textFieldDidEndEditing:)])
        [originalDelegate textFieldDidEndEditing:textField];
}

- (void)textFieldDidChangeEditing:(UITextField *)textField {
    if (self.didChangeBlock)
        self.didChangeBlock(textField);
}

@end
