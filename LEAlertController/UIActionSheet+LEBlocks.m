//
//  UIActionSheet+LEBlocks.m
//  LEAlertController
//
//  Created by Lasha Efremidze on 3/25/15.
//  Copyright (c) 2015 Lasha Efremidze. All rights reserved.
//

#import "UIActionSheet+LEBlocks.h"

#import <objc/runtime.h>

static char UIActionSheetDelegateKey;

static char UIActionSheetDidPresentBlockKey;
static char UIActionSheetClickedButtonBlockKey;

@interface UIActionSheet () <UIActionSheetDelegate>

@end

@implementation UIActionSheet (LEBlocks)

- (void)checkDelegate
{
    if (self.delegate != self) {
        objc_setAssociatedObject(self, &UIActionSheetDelegateKey, self.delegate, OBJC_ASSOCIATION_ASSIGN);
        self.delegate = self;
    }
}

- (id<UIActionSheetDelegate>)originalDelegate
{
    return objc_getAssociatedObject(self, &UIActionSheetDelegateKey);
}

#pragma mark -

- (UIActionSheetBlock)didPresentBlock
{
    return objc_getAssociatedObject(self, &UIActionSheetDidPresentBlockKey);
}

- (void)setDidPresentBlock:(UIActionSheetBlock)didPresentBlock
{
    [self checkDelegate];
    objc_setAssociatedObject(self, &UIActionSheetDidPresentBlockKey, didPresentBlock, OBJC_ASSOCIATION_COPY);
}

- (UIActionSheetCompletionBlock)clickedButtonBlock
{
    return objc_getAssociatedObject(self, &UIActionSheetClickedButtonBlockKey);
}

- (void)setClickedButtonBlock:(UIActionSheetCompletionBlock)clickedButtonBlock
{
    [self checkDelegate];
    objc_setAssociatedObject(self, &UIActionSheetClickedButtonBlockKey, clickedButtonBlock, OBJC_ASSOCIATION_COPY);
}

#pragma mark - UIActionSheetDelegate

- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
    UIActionSheetBlock block = self.didPresentBlock;
    if (block)
        block(actionSheet);
    
    id originalDelegate = [self originalDelegate];
    if ([originalDelegate respondsToSelector:@selector(didPresentActionSheet:)])
        [originalDelegate didPresentActionSheet:actionSheet];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIActionSheetCompletionBlock block = self.clickedButtonBlock;
    if (block)
        block(actionSheet, buttonIndex);

    id originalDelegate = [self originalDelegate];
    if ([originalDelegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)])
        [originalDelegate actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
}

@end
