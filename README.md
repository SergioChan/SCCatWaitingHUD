# SCCatWaitingHUD

This is a cute and simple loading HUD :-P Enjoy!

[![CI Status](http://img.shields.io/travis/SergioChan/SCCatWaitingHUD.svg?style=flat)](https://travis-ci.org/SergioChan/SCCatWaitingHUD)
[![Version](https://img.shields.io/cocoapods/v/SCCatWaitingHUD.svg?style=flat)](http://cocoapods.org/pods/SCCatWaitingHUD)
[![License](https://img.shields.io/cocoapods/l/SCCatWaitingHUD.svg?style=flat)](http://cocoapods.org/pods/SCCatWaitingHUD)
[![Platform](https://img.shields.io/cocoapods/p/SCCatWaitingHUD.svg?style=flat)](http://cocoapods.org/pods/SCCatWaitingHUD)

## Preview

![image](https://raw.githubusercontent.com/SergioChan/SCCatWaitingHUD/master/Preview/preview.png)

![image](https://raw.githubusercontent.com/SergioChan/SCCatWaitingHUD/master/Preview/preview.gif)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

Simply use as below :

```Objective-C
if(![SCCatWaitingHUD sharedInstance].isAnimating)
{
    [[SCCatWaitingHUD sharedInstance] animate];
}
else
{
    [[SCCatWaitingHUD sharedInstance] stop];
}
```

## BackLog
* v0.1.0 Basic Version
* v0.1.1 Add Landscape Orientation Support

## Requirements
iOS 8.0 Above

## Installation

SCCatWaitingHUD is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SCCatWaitingHUD', '~> 0.1.1'
```

## License

SCCatWaitingHUD is available under the MIT license. See the LICENSE file for more info.
