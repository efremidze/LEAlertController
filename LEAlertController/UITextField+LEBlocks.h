//
//  UITextField+LEBlocks.h
//  LEAlertControllerDemo
//
//  Created by Vlad Getman on 02.09.15.
//  Copyright (c) 2015 Lasha Efremidze. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TextFieldBlock)(UITextField *textField);

@interface UITextField (LEBlocks)

@property (nonatomic, copy) TextFieldBlock didChangeBlock;

@end
