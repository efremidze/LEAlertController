//
//  LEAlertAction.h
//  LEAlertControllerDemo
//
//  Created by Lasha Efremidze on 4/8/15.
//  Copyright (c) 2015 Lasha Efremidze. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LEAlertAction;

typedef NS_ENUM(NSInteger, LEAlertActionStyle) {
    LEAlertActionStyleDefault = 0,
    LEAlertActionStyleCancel,
    LEAlertActionStyleDestructive
};

typedef void (^LEAlertActionHandler)(LEAlertAction *action);

@interface LEAlertAction : NSObject <NSCopying>

+ (instancetype)actionWithTitle:(NSString *)title style:(LEAlertActionStyle)style handler:(LEAlertActionHandler)handler;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) LEAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@end
