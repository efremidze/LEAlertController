//
//  LEAlertController.m
//  LEAlertController
//
//  Created by Lasha Efremidze on 3/25/15.
//  Copyright (c) 2015 Lasha Efremidze. All rights reserved.
//

#import "LEAlertController.h"

#import "UIAlertView+LEBlocks.h"
#import "UIActionSheet+LEBlocks.h"
#import "UITextField+LEBlocks.h"

#pragma mark - LEAlertAction

@interface LEAlertAction ()

@property (nonatomic, copy) LEAlertActionHandler handler;

@end

@implementation LEAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(LEAlertActionStyle)style handler:(LEAlertActionHandler)handler;
{
    return [[self alloc] initWithTitle:title style:style handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title style:(LEAlertActionStyle)style handler:(LEAlertActionHandler)handler;
{
    if (self = [super init]) {
        _title = title;
        _style = style;
        _handler = handler;
    }
    return self;
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    return [[LEAlertAction allocWithZone:zone] initWithTitle:self.title.copy style:self.style handler:self.handler];
}

@end

#pragma mark - LEAlertController

@interface LEAlertController ()

@property (nonatomic, strong) NSMutableArray *mutableActions;
@property (nonatomic, strong) NSMutableArray *mutableTextFields;

@property (nonatomic, strong) NSMutableDictionary *configurationHandlers;

@property (nonatomic, strong) UIAlertController *alertController;

@end

@implementation LEAlertController

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(LEAlertControllerStyle)preferredStyle;
{
    return [[self alloc] initWithTitle:title message:message preferredStyle:preferredStyle];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(LEAlertControllerStyle)preferredStyle;
{
    if (self = [super init]) {
        _title = title;
        _message = message;
        _preferredStyle = preferredStyle;
        
        _mutableActions = [NSMutableArray array];
        _mutableTextFields = [NSMutableArray array];
        
        _configurationHandlers = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark -

- (NSArray *)actions
{
    return self.mutableActions.copy;
}

- (NSArray *)textFields
{
    return self.alertController.textFields;
}

#pragma mark -

- (void)addAction:(LEAlertAction *)action;
{
    [self.mutableActions addObject:action];
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler;
{
    UITextField *textField = [UITextField new];
    if (configurationHandler)
        configurationHandler(textField);
    [self.mutableTextFields addObject:textField];
    
    if ([UIAlertController class]) {
        textField.didChangeBlock = ^(UITextField *textField) {
            if (self.shouldEnableFirstOtherButtonBlock && self.alertController) {
                [self checkEnableFirstOtherButtonBlock];
            }
        };
    }
    
    if (configurationHandler)
        self.configurationHandlers[[NSValue valueWithNonretainedObject:textField]] = configurationHandler;
}

- (void)addShouldEnableFirstOtherButtonHandler:(BOOL (^)(LEAlertController *))handler {
    self.shouldEnableFirstOtherButtonBlock = handler;
}

- (void)textFieldDidChangeEditing:(UITextField *)textField {
    if (self.shouldEnableFirstOtherButtonBlock && self.alertController) {
        [self checkEnableFirstOtherButtonBlock];
    }
}

- (void)checkEnableFirstOtherButtonBlock {
    for (UIAlertAction *action in self.alertController.actions) {
        if (action.style != UIAlertActionStyleCancel) {
            action.enabled = self.shouldEnableFirstOtherButtonBlock(self);
            return;
        }
    }
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    LEAlertController *alertController = [[LEAlertController allocWithZone:zone] initWithTitle:self.title.copy message:self.message.copy preferredStyle:self.preferredStyle];
    
    for (LEAlertAction *action in self.actions) {
        [alertController addAction:action.copy];
    }
    
    for (UITextField *textField in self.mutableTextFields.copy) {
        [alertController addTextFieldWithConfigurationHandler:self.configurationHandlers[[NSValue valueWithNonretainedObject:textField]]];
    }
    
    return alertController;
}

@end

#pragma mark - UIViewController (LEAlertController)

@implementation UIViewController (LEAlertController)

- (void)presentAlertController:(LEAlertController *)alertController animated:(BOOL)animated completion:(void (^)(void))completion;
{
    if ([UIAlertController class]) {
        UIAlertController *newAlertController = [UIAlertController alertControllerWithTitle:alertController.title message:alertController.message preferredStyle:(UIAlertControllerStyle)alertController.preferredStyle];
        
        for (LEAlertAction *action in alertController.actions) {
            UIAlertAction *newAction = [UIAlertAction actionWithTitle:action.title style:(UIAlertActionStyle)action.style handler:^(UIAlertAction *newAction) {
                if (action.handler)
                    action.handler(action);
            }];
            [newAlertController addAction:newAction];
        }
        
        for (UITextField *textField in alertController.mutableTextFields.copy) {
            [newAlertController addTextFieldWithConfigurationHandler:^(UITextField *newTextField) {
                void (^handler)(UITextField *textField) = alertController.configurationHandlers[[NSValue valueWithNonretainedObject:textField]];
                if (handler)
                    handler(newTextField);
                newTextField.didChangeBlock = ^(UITextField *textField) {
                    if (alertController.shouldEnableFirstOtherButtonBlock && alertController.alertController) {
                        [alertController checkEnableFirstOtherButtonBlock];
                    }
                };
            }];
        }
        alertController.alertController = newAlertController;
        [alertController checkEnableFirstOtherButtonBlock];
        
        [self presentViewController:newAlertController animated:animated completion:completion];
    } else {
        if (alertController.preferredStyle == LEAlertControllerStyleAlert) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertController.title message:alertController.message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            
            for (LEAlertAction *action in alertController.actions) {
                [alertView addButtonWithTitle:action.title];
                
                if (alertView.cancelButtonIndex == -1 && action.style == LEAlertActionStyleCancel)
                    alertView.cancelButtonIndex = alertView.numberOfButtons - 1;
                
                action.enabled = YES;
            }
            
            if (alertController.mutableTextFields.count) {
                if (alertController.mutableTextFields.count == 1) {
                    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                    
                    UITextField *textField = [alertView textFieldAtIndex:0];
                    alertController.mutableTextFields = [NSMutableArray arrayWithObject:textField];
                } else {
                    alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
                    
                    UITextField *firstTextField = [alertView textFieldAtIndex:0];
                    UITextField *secondTextField = [alertView textFieldAtIndex:1];
                    alertController.mutableTextFields = [NSMutableArray arrayWithObjects:firstTextField, secondTextField, nil];
                }
            }
            
            alertView.didPresentBlock = ^(UIAlertView *alertView){
                if (completion)
                    completion();
            };
            
            alertView.clickedButtonBlock = ^(UIAlertView *alertView, NSInteger buttonIndex){
                LEAlertAction *action = alertController.actions[buttonIndex];
                if (action.handler)
                    action.handler(action);
            };
            alertView.shouldEnableFirstOtherButtonBlock = ^(UIAlertView *alertView) {
                if (alertController.shouldEnableFirstOtherButtonBlock) {
                    return alertController.shouldEnableFirstOtherButtonBlock(alertController);
                } else {
                    return YES;
                }
            };
            [alertView show];
        } else {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:alertController.title delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            
            for (LEAlertAction *action in alertController.actions) {
                [actionSheet addButtonWithTitle:action.title];
                
                if (actionSheet.cancelButtonIndex == -1 && action.style == LEAlertActionStyleCancel)
                    actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
                
                if (actionSheet.destructiveButtonIndex == -1 && action.style == LEAlertActionStyleDestructive)
                    actionSheet.destructiveButtonIndex = actionSheet.numberOfButtons - 1;
                
                action.enabled = YES;
            }
            
            actionSheet.didPresentBlock = ^(UIActionSheet *actionSheet){
                if (completion)
                    completion();
            };
            
            actionSheet.clickedButtonBlock = ^(UIActionSheet *actionSheet, NSInteger buttonIndex){
                LEAlertAction *action = alertController.actions[buttonIndex];
                if (action.handler)
                    action.handler(action);
            };
            
            [actionSheet showInView:self.view];
        }
    }
}

@end
