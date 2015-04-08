//
//  UIActionSheet+LEBlocks.h
//  LEAlertController
//
//  Created by Lasha Efremidze on 3/25/15.
//  Copyright (c) 2015 Lasha Efremidze. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIActionSheetBlock)(UIActionSheet *actionSheet);
typedef void (^UIActionSheetCompletionBlock)(UIActionSheet *actionSheet, NSInteger buttonIndex);

@interface UIActionSheet (LEBlocks)

@property (nonatomic, copy) UIActionSheetBlock didPresentBlock;
@property (nonatomic, copy) UIActionSheetCompletionBlock clickedButtonBlock;

@end
