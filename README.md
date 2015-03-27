# LEAlertController

[![CI Status](http://img.shields.io/travis/Lasha Efremidze/LEAlertController.svg?style=flat)](https://travis-ci.org/Lasha Efremidze/LEAlertController)
[![Version](https://img.shields.io/cocoapods/v/LEAlertController.svg?style=flat)](http://cocoapods.org/pods/LEAlertController)
[![License](https://img.shields.io/cocoapods/l/LEAlertController.svg?style=flat)](http://cocoapods.org/pods/LEAlertController)
[![Platform](https://img.shields.io/cocoapods/p/LEAlertController.svg?style=flat)](http://cocoapods.org/pods/LEAlertController)

## Overview

`LEAlertController` is a lightweight `UIAlertController` extension for iOS 7 support. Fallbacks to using `UIAlertView` and `UIActionSheet` for iOS 7.

![UIAlertView Screenshot](Screenshots/alert.png)
![UIActionSheet Screenshot](Screenshots/actionsheet.png)

## Usage

### Installation

LEAlertController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LEAlertController"
```
To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Example

```objectivec
// Alert

LEAlertController *alertController = [LEAlertController alertControllerWithTitle:@"Default Style" message:@"A standard alert." preferredStyle:LEAlertControllerStyleAlert];

LEAlertAction *cancelAction = [LEAlertAction actionWithTitle:@"Cancel" style:LEAlertActionStyleCancel handler:^(LEAlertAction *action) {
// handle cancel button action
}];
[alertController addAction:cancelAction];

LEAlertAction *defaultAction = [LEAlertAction actionWithTitle:@"OK" style:LEAlertActionStyleDefault handler:^(LEAlertAction *action) {
// handle default button action
}];
[alertController addAction:defaultAction];

[self presentAlertController:alertController animated:YES completion:nil];

// Action Sheet

LEAlertController *alertController = [LEAlertController alertControllerWithTitle:nil message:@"A standard action sheet." preferredStyle:LEAlertControllerStyleActionSheet];

LEAlertAction *destructiveAction = [LEAlertAction actionWithTitle:@"Destroy" style:LEAlertActionStyleDestructive handler:^(LEAlertAction *action) {
// handle destructive button action
}];
[alertController addAction:destructiveAction];

LEAlertAction *defaultAction = [LEAlertAction actionWithTitle:@"OK" style:LEAlertActionStyleDefault handler:^(LEAlertAction *action) {
// handle default button action
}];
[alertController addAction:defaultAction];

LEAlertAction *cancelAction = [LEAlertAction actionWithTitle:@"Cancel" style:LEAlertActionStyleCancel handler:^(LEAlertAction *action) {
// handle cancel button action
}];
[alertController addAction:cancelAction];

[self presentAlertController:alertController animated:YES completion:nil];
```

## Author

Lasha Efremidze, efremidzel@hotmail.com

## License

LEAlertController is available under the MIT license. See the LICENSE file for more info.
