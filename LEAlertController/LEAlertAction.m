//
//  LEAlertAction.m
//  LEAlertControllerDemo
//
//  Created by Lasha Efremidze on 4/8/15.
//  Copyright (c) 2015 Lasha Efremidze. All rights reserved.
//

#import "LEAlertAction.h"

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
