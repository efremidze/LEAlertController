# LEAlertController

[![CI Status](http://img.shields.io/travis/Lasha Efremidze/LEAlertController.svg?style=flat)](https://travis-ci.org/Lasha Efremidze/LEAlertController)
[![Version](https://img.shields.io/cocoapods/v/LEAlertController.svg?style=flat)](http://cocoapods.org/pods/LEAlertController)
[![License](https://img.shields.io/cocoapods/l/LEAlertController.svg?style=flat)](http://cocoapods.org/pods/LEAlertController)
[![Platform](https://img.shields.io/cocoapods/p/LEAlertController.svg?style=flat)](http://cocoapods.org/pods/LEAlertController)

## Overview

`LEAlertController` is a lightweight `UIAlertController` extension for iOS 7 support. Fallbacks to using `UIAlertView` and `UIActionSheet` for iOS 7.

![UIAlertView Screenshot](Screenshots/uialertview.png)
![UIActionSheet Screenshot](Screenshots/uiactionsheet.png)

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
MCAlertController *alertController = [MCAlertController alertControllerWithTitle:@"Default Style" message:@"A standard alert." preferredStyle:MCAlertControllerStyleAlert cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@[@"OK"] handler:^(id alertController, NSString *buttonTitle) {
    // handle button action
}];
[self presentAlertController:alertController animated:YES];
```

## Author

Lasha Efremidze, efremidzel@hotmail.com

## License

LEAlertController is available under the MIT license. See the LICENSE file for more info.
