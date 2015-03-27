//
//  LEAlertController.m
//  LEAlertController
//
//  Created by Lasha Efremidze on 3/25/15.
//  Copyright (c) 2015 efremidze. All rights reserved.
//

#import "LEAlertController.h"

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

@interface LEAlertController () <UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) NSMutableArray *mutableActions;
@property (nonatomic, strong) NSMutableArray *mutableTextFields;

@property (nonatomic, strong) NSMutableDictionary *configurationHandlers;

@property (nonatomic, copy) void (^didPresentCompletionHandler)(void);

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
    return [self.mutableActions copy];
}

- (NSArray *)textFields
{
    return [self.mutableTextFields copy];
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
    
    if (configurationHandler)
        self.configurationHandlers[[NSValue valueWithNonretainedObject:textField]] = configurationHandler;
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    LEAlertController *alertController = [[LEAlertController allocWithZone:zone] initWithTitle:self.title.copy message:self.message.copy preferredStyle:self.preferredStyle];
    
    for (LEAlertAction *alertAction in self.actions) {
        [alertController addAction:alertAction.copy];
    }
    
    for (UITextField *textField in self.textFields) {
        [alertController addTextFieldWithConfigurationHandler:self.configurationHandlers[[NSValue valueWithNonretainedObject:textField]]];
    }
        
    return alertController;
}

#pragma mark - UIAlertViewDelegate

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    if (self.didPresentCompletionHandler)
        self.didPresentCompletionHandler();
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    LEAlertAction *action = self.actions[buttonIndex];
    if (action.handler)
        action.handler(action);
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.didDismissCompletionHandler)
        self.didDismissCompletionHandler(buttonIndex);
}

#pragma mark - UIActionSheetDelegate

- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
    if (self.didPresentCompletionHandler)
        self.didPresentCompletionHandler();
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    LEAlertAction *action = self.actions[buttonIndex];
    if (action.handler)
        action.handler(action);
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.didDismissCompletionHandler)
        self.didDismissCompletionHandler(buttonIndex);
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
        
        for (UITextField *textField in alertController.textFields) {
            [newAlertController addTextFieldWithConfigurationHandler:^(UITextField *newTextField) {
                void (^handler)(UITextField *textField) = alertController.configurationHandlers[[NSValue valueWithNonretainedObject:textField]];
                if (handler)
                    handler(newTextField);
            }];
        }
        
        [self presentViewController:newAlertController animated:animated completion:completion];
    } else {
        alertController.didPresentCompletionHandler = completion;
        
        if (alertController.preferredStyle == LEAlertControllerStyleAlert) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertController.title message:alertController.message delegate:(id<UIAlertViewDelegate>)alertController cancelButtonTitle:nil otherButtonTitles:nil];
            
            for (LEAlertAction *action in alertController.actions) {
                [alertView addButtonWithTitle:action.title];
                
                if (alertView.cancelButtonIndex == -1 && action.style == LEAlertActionStyleCancel)
                    alertView.cancelButtonIndex = alertView.numberOfButtons - 1;
                
                action.enabled = YES;
            }
            
            if (alertController.textFields.count) {
                if (alertController.textFields.count == 1) {
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
            
            [(UIAlertView *)alertController show];
        } else {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:alertController.title delegate:(id<UIActionSheetDelegate>)alertController cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            
            for (LEAlertAction *action in alertController.actions) {
                [actionSheet addButtonWithTitle:action.title];
                
                if (actionSheet.cancelButtonIndex == -1 && action.style == LEAlertActionStyleCancel)
                    actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
                
                if (actionSheet.destructiveButtonIndex == -1 && action.style == LEAlertActionStyleDestructive)
                    actionSheet.destructiveButtonIndex = actionSheet.numberOfButtons - 1;
                
                action.enabled = YES;
            }
            
            [(UIActionSheet *)alertController showInView:self.view];
        }
    }
}

@end
