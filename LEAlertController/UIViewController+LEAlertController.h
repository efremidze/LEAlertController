//
//  UIViewController+LEAlertController.h
//  LEAlertControllerDemo
//
//  Created by Lasha Efremidze on 4/8/15.
//  Copyright (c) 2015 Lasha Efremidze. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LEAlertController;

@interface UIViewController (LEAlertController)

- (void)presentAlertController:(LEAlertController *)alertController animated:(BOOL)animated completion:(void (^)(void))completion;

@end
