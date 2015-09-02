//
//  UIAlertView+LEBlocks.m
//  LEAlertController
//
//  Created by Lasha Efremidze on 3/25/15.
//  Copyright (c) 2015 Lasha Efremidze. All rights reserved.
//

#import "UIAlertView+LEBlocks.h"

#import <objc/runtime.h>

static char UIAlertViewDelegateKey;

static char UIAlertViewDidPresentBlockKey;
static char UIAlertViewClickedButtonBlockKey;
static char UIAlertViewShouldEnableFirstOtherButtonBlockKey;

@interface UIAlertView () <UIAlertViewDelegate>

@end

@implementation UIAlertView (LEBlocks)

- (void)checkDelegate
{
    if (self.delegate != self) {
        objc_setAssociatedObject(self, &UIAlertViewDelegateKey, self.delegate, OBJC_ASSOCIATION_ASSIGN);
        self.delegate = self;
    }
}

- (id<UIActionSheetDelegate>)originalDelegate
{
    return objc_getAssociatedObject(self, &UIAlertViewDelegateKey);
}

#pragma mark -

- (UIAlertViewBlock)didPresentBlock
{
    return objc_getAssociatedObject(self, &UIAlertViewDidPresentBlockKey);
}

- (void)setDidPresentBlock:(UIAlertViewBlock)didPresentBlock
{
    [self checkDelegate];
    objc_setAssociatedObject(self, &UIAlertViewDidPresentBlockKey, didPresentBlock, OBJC_ASSOCIATION_COPY);
}

- (UIAlertViewCompletionBlock)clickedButtonBlock
{
    return objc_getAssociatedObject(self, &UIAlertViewClickedButtonBlockKey);
}

- (void)setClickedButtonBlock:(UIAlertViewCompletionBlock)clickedButtonBlock
{
    [self checkDelegate];
    objc_setAssociatedObject(self, &UIAlertViewClickedButtonBlockKey, clickedButtonBlock, OBJC_ASSOCIATION_COPY);
}

- (void)setShouldEnableFirstOtherButtonBlock:(BOOL(^)(UIAlertView *alertView))shouldEnableFirstOtherButtonBlock {
    [self checkDelegate];
    objc_setAssociatedObject(self, &UIAlertViewShouldEnableFirstOtherButtonBlockKey, shouldEnableFirstOtherButtonBlock, OBJC_ASSOCIATION_COPY);
}

- (BOOL(^)(UIAlertView *alertView))shouldEnableFirstOtherButtonBlock {
    return objc_getAssociatedObject(self, &UIAlertViewShouldEnableFirstOtherButtonBlockKey);
}

#pragma mark - UIAlertViewDelegate

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    UIAlertViewBlock block = self.didPresentBlock;
    if (block)
        block(alertView);
    
    id originalDelegate = [self originalDelegate];
    if ([originalDelegate respondsToSelector:@selector(didPresentAlertView:)])
        [originalDelegate didPresentAlertView:alertView];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIAlertViewCompletionBlock block = self.clickedButtonBlock;
    if (block)
        block(alertView, buttonIndex);
    
    id originalDelegate = [self originalDelegate];
    if ([originalDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
        [originalDelegate alertView:alertView clickedButtonAtIndex:buttonIndex];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    
    BOOL(^shouldEnableFirstOtherButtonBlock)(UIAlertView *alertView) = alertView.shouldEnableFirstOtherButtonBlock;
    if (shouldEnableFirstOtherButtonBlock) {
        return shouldEnableFirstOtherButtonBlock(alertView);
    }
    
    id originalDelegate = [self originalDelegate];
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(alertViewShouldEnableFirstOtherButton:)]) {
        return [originalDelegate alertViewShouldEnableFirstOtherButton:alertView];
    }
    
    return YES;
}

@end
