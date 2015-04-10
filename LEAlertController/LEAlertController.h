//
//  LEAlertController.h
//  LEAlertController
//
//  Created by Lasha Efremidze on 3/25/15.
//  Copyright (c) 2015 Lasha Efremidze. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LEAlertAction.h"

#import "UIViewController+LEAlertController.h"

typedef NS_ENUM(NSInteger, LEAlertControllerStyle) {
    LEAlertControllerStyleActionSheet = 0,
    LEAlertControllerStyleAlert
};

typedef void (^LEAlertControllerCompletionBlock)(id sender, NSInteger buttonIndex);

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
