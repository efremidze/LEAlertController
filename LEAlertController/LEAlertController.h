//
//  LEAlertController.h
//  LEAlertController
//
//  Created by Lasha Efremidze on 3/25/15.
//  Copyright (c) 2015 Lasha Efremidze. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LEAlertActionStyle) {
    LEAlertActionStyleDefault = 0,
    LEAlertActionStyleCancel,
    LEAlertActionStyleDestructive
};

typedef NS_ENUM(NSInteger, LEAlertControllerStyle) {
    LEAlertControllerStyleActionSheet = 0,
    LEAlertControllerStyleAlert
};

@class LEAlertAction;

typedef void (^LEAlertActionHandler)(LEAlertAction *action);

typedef void (^LEAlertControllerCompletionBlock)(id sender, NSInteger buttonIndex);

#pragma mark - LEAlertAction

@interface LEAlertAction : NSObject <NSCopying>

+ (instancetype)actionWithTitle:(NSString *)title style:(LEAlertActionStyle)style handler:(LEAlertActionHandler)handler;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) LEAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@end

#pragma mark - LEAlertController

@interface LEAlertController : NSObject <NSCopying>

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(LEAlertControllerStyle)preferredStyle;

- (void)addAction:(LEAlertAction *)action;
@property (nonatomic, readonly) NSArray *actions;
- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler;
@property (nonatomic, readonly) NSArray *textFields;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, readonly) LEAlertControllerStyle preferredStyle;

@end

#pragma mark - UIViewController (LEAlertController)

@interface UIViewController (LEAlertController)

- (void)presentAlertController:(LEAlertController *)alertController animated:(BOOL)animated completion:(void (^)(void))completion;

@end
