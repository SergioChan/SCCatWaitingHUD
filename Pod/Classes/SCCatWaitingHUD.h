//
//  SCCatWaitingHUD.h
//  SCCatWaitingHUD
//
//  Created by Yh c on 15/11/13.
//  Copyright © 2015年 Animatious. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewExt.h"

#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height

#define SCCatWaiting_catPurple [UIColor colorWithRed:75.0f/255.0f green:52.0f/255.0f blue:97.0f/255.0f alpha:0.7f]
#define SCCatWaiting_leftFaceGray [UIColor colorWithRed:200.0f/255.0f green:198.0f/255.0f blue:200.0f/255.0f alpha:1.0f]
#define SCCatWaiting_rightFaceGray [UIColor colorWithRed:213.0f/255.0f green:212.0f/255.0f blue:213.0f/255.0f alpha:1.0f]

#define SCCatWaiting_animationSize 50.0f

@interface SCCatWaitingHUD : UIView

@property (nonatomic, strong) UIWindow *backgroundWindow;

@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) UIImageView *faceView;
@property (nonatomic, strong) UIImageView *mouseView;
@property (nonatomic, strong) UILabel *contentLabel;

/**
 *  Status of animation.
 */
@property (nonatomic) BOOL isAnimating;

/**
 *  Title of your HUD. Display in contentLabel. Default is 'Loading...'
 */
@property (nonatomic, strong) NSString *title;

+ (SCCatWaitingHUD *) sharedInstance;
- (void)animate;

/**
 *  动画的时候是否允许和原始的View进行交互
 *  Whether you can interact with the original view while animating
 *
 *  @param enabled YES代表能响应原生View事件，NO代表block当前所有的手势操作
 */
- (void)animateWithInteractionEnabled:(BOOL)enabled;

/**
 *  You can attach your HUD title to the view using this animation method. Default title is 'Loading...'.
 *
 *  @param enabled YES代表能响应原生View事件，NO代表block当前所有的手势操作
 *  @param title   HUD title
 */
- (void)animateWithInteractionEnabled:(BOOL)enabled title:(NSString *)title;

/**
 *  You can also customize duration for each loop (also can be represented as speed) using this animation method. Default duration is 4.0 seconds each loop.
 *
 *  @param enabled YES代表能响应原生View事件，NO代表block当前所有的手势操作
 *  @param title   HUD title
 *  @param duration time for each loop
 */
- (void)animateWithInteractionEnabled:(BOOL)enabled title:(NSString *)title duration:(CGFloat)duration;

- (void)stop;
@end
