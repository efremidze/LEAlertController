//
//  UIViewController+LEAlertController.m
//  LEAlertControllerDemo
//
//  Created by Lasha Efremidze on 4/8/15.
//  Copyright (c) 2015 Lasha Efremidze. All rights reserved.
//

#import "UIViewController+LEAlertController.h"

#import "LEAlertController.h"
#import "UIAlertView+LEBlocks.h"
#import "UIActionSheet+LEBlocks.h"

@interface LEAlertController ()

@property (nonatomic, strong) NSMutableArray *mutableActions;
@property (nonatomic, strong) NSMutableArray *mutableTextFields;

@property (nonatomic, strong) NSMutableDictionary *configurationHandlers;

@end

@interface LEAlertAction ()

@property (nonatomic, copy) LEAlertActionHandler handler;

@end

@interface UIViewController ()

@end

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
        if (alertController.preferredStyle == LEAlertControllerStyleAlert) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertController.title message:alertController.message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            
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
            
            alertView.didPresentBlock = ^(UIAlertView *alertView){
                if (completion)
                    completion();
            };
            
            alertView.clickedButtonBlock = ^(UIAlertView *alertView, NSInteger buttonIndex){
                LEAlertAction *action = alertController.actions[buttonIndex];
                if (action.handler)
                    action.handler(action);
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
