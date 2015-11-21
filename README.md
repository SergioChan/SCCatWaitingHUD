# SCCatWaitingHUD

This is a cute and simple loading HUD :-P Enjoy!  
这是一个可爱清新简单的加载HUD控件 :-P

[![CI Status](http://img.shields.io/travis/SergioChan/SCCatWaitingHUD.svg?style=flat)](https://travis-ci.org/SergioChan/SCCatWaitingHUD)
[![Version](https://img.shields.io/cocoapods/v/SCCatWaitingHUD.svg?style=flat)](http://cocoapods.org/pods/SCCatWaitingHUD)
[![License](https://img.shields.io/cocoapods/l/SCCatWaitingHUD.svg?style=flat)](http://cocoapods.org/pods/SCCatWaitingHUD)
[![Platform](https://img.shields.io/cocoapods/p/SCCatWaitingHUD.svg?style=flat)](http://cocoapods.org/pods/SCCatWaitingHUD)

## Preview 预览

![image](https://raw.githubusercontent.com/SergioChan/SCCatWaitingHUD/master/Preview/preview.png)

![image](https://raw.githubusercontent.com/SergioChan/SCCatWaitingHUD/master/Preview/preview.gif)

## Usage 用法

To run the example project, clone the repo, and run `pod install` from the Example directory first.  
想要运行示例工程，将这个仓库clone到本地，在`Example`目录下运行`pod install`。

Simply use as below :  
用法很简单：

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

Here I provided you several complex ways to call the `animate` method.  
有些加载交互是需要block用户当前操作的，因此在这里我提供了两种更复杂一些的方式来调用`animate`方法。

```Objective-C
/**
 *  动画的时候是否允许和原始的View进行交互
 *  Whether you can interact with the original view while animating
 *
 *  @param enabled YES代表能响应原生View事件，NO代表block当前所有的手势操作
 */
- (void)animateWithInteractionEnabled:(BOOL)enabled;

/**
 *  You can attach your HUD title to the view using this animation method.
 *
 *  @param enabled YES代表能响应原生View事件，NO代表block当前所有的手势操作
 *  @param title   HUD title
 */
- (void)animateWithInteractionEnabled:(BOOL)enabled title:(NSString *)title;
```

Moreover, I provided a new method to call `animate` in version 0.1.6 that can give you ablity to customize the duration for each loop.  
另外我在0.1.6版本提供了一个更新的调用 `animate` 方法的接口，可以让你自定义每转一圈的时长，从而修改旋转的速度，默认值是4秒一圈，在这个速度上看老鼠跑的不会异常的快，当然提供给你这个方法是让你可以让它跑得更快。

```Objective-C
/**
*  You can also customize duration for each loop (also can be represented as speed) using this animation method. Default duration is 4.0 seconds each loop.
*
*  @param enabled YES代表能响应原生View事件，NO代表block当前所有的手势操作
*  @param title   HUD title
*  @param duration time for each loop
*/
- (void)animateWithInteractionEnabled:(BOOL)enabled title:(NSString *)title duration:(CGFloat)duration;
```
## BackLog 更新日志
* v0.1.0 Basic Version
* v0.1.1 Add Landscape Orientation Support
* v0.1.4 Add eye cover and Loading contentLabel animation
* v0.1.5 Finish perfect timing function for eye cover movement and polish some of the codes
* v0.1.6 Add a new animate method that can customize duration for each loop

--

* v0.1.0 基本版本
* v0.1.1 支持横屏
* v0.1.4 添加眼皮运动和下方Loading字样的Label
* v0.1.5 优化代码结构，精确调整了眼皮和眼珠的运动时间曲线
* v0.1.6 添加一个新的animate方法入口

## Requirements 版本需求
iOS 8.0 Above

## Installation 安装

SCCatWaitingHUD is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SCCatWaitingHUD', '~> 0.1.6'
```

## License

SCCatWaitingHUD is available under the MIT license. See the LICENSE file for more info.
