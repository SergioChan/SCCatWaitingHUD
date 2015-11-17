//
//  SCCatWaitingHUD.h
//  SCCatWaitingHUD
//
//  Created by Yh c on 15/11/13.
//  Copyright © 2015年 Animatious. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalHeader.h"

@interface SCCatWaitingHUD : UIView

@property (nonatomic, strong) UIWindow *backgroundWindow;

@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) UIImageView *faceView;
@property (nonatomic, strong) UIImageView *mouseView;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIView *leftEye;
@property (nonatomic, strong) UIView *rightEye;

@property (nonatomic) BOOL isAnimating;

@property (nonatomic) CGFloat easeInDuration;
@property (nonatomic) CGFloat animationDuration;

@property (nonatomic) UIInterfaceOrientation previousOrientation;

//@property (nonatomic, strong) CABasicAnimation *currentAnimation;
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
- (void)animateWithInteractionEnabled:(BOOL)enabled title:(NSString *)title;

- (void)stop;
@end
