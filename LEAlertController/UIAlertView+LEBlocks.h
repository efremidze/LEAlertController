//
//  UIAlertView+LEBlocks.h
//  LEAlertController
//
//  Created by Lasha Efremidze on 3/25/15.
//  Copyright (c) 2015 Lasha Efremidze. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIAlertViewBlock)(UIAlertView *alertView);
typedef void (^UIAlertViewCompletionBlock)(UIAlertView *alertView, NSInteger buttonIndex);

@interface UIAlertView (LEBlocks)

@property (nonatomic, copy) UIAlertViewBlock didPresentBlock;
@property (nonatomic, copy) UIAlertViewCompletionBlock clickedButtonBlock;

@end
