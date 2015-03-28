//
//  ViewController.m
//  LEAlertController
//
//  Created by Lasha Efremidze on 3/26/15.
//  Copyright (c) 2015 Lasha Efremidze. All rights reserved.
//

#import "ViewController.h"
#import "LEAlertController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTouchOnAlertButton:(id)sender
{
    LEAlertController *alertController = [LEAlertController alertControllerWithTitle:@"Default Style" message:@"A standard alert." preferredStyle:LEAlertControllerStyleAlert];
    
    LEAlertAction *cancelAction = [LEAlertAction actionWithTitle:@"Cancel" style:LEAlertActionStyleCancel handler:^(LEAlertAction *action) {
        // handle cancel button action
        NSLog(@"cancel button pressed");
    }];
    [alertController addAction:cancelAction];
    
    LEAlertAction *defaultAction = [LEAlertAction actionWithTitle:@"OK" style:LEAlertActionStyleDefault handler:^(LEAlertAction *action) {
        // handle default button action
        NSLog(@"default button pressed");
    }];
    [alertController addAction:defaultAction];
    
    [self presentAlertController:alertController animated:YES completion:nil];
}

- (IBAction)didTouchOnActionSheetButton:(id)sender
{
    LEAlertController *alertController = [LEAlertController alertControllerWithTitle:nil message:@"A standard action sheet." preferredStyle:LEAlertControllerStyleActionSheet];
    
    LEAlertAction *destructiveAction = [LEAlertAction actionWithTitle:@"Destroy" style:LEAlertActionStyleDestructive handler:^(LEAlertAction *action) {
        // handle destructive button action
        NSLog(@"destructive button pressed");
    }];
    [alertController addAction:destructiveAction];
    
    LEAlertAction *defaultAction = [LEAlertAction actionWithTitle:@"OK" style:LEAlertActionStyleDefault handler:^(LEAlertAction *action) {
        // handle default button action
        NSLog(@"default button pressed");
    }];
    [alertController addAction:defaultAction];
    
    LEAlertAction *cancelAction = [LEAlertAction actionWithTitle:@"Cancel" style:LEAlertActionStyleCancel handler:^(LEAlertAction *action) {
        // handle cancel button action
        NSLog(@"cancel button pressed");
    }];
    [alertController addAction:cancelAction];
    
    [self presentAlertController:alertController animated:YES completion:nil];
}

@end
