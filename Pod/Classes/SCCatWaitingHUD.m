//
//  SCCatWaitingHUD.m
//  SCCatWaitingHUD
//
//  Created by Yh c on 15/11/13.
//  Copyright © 2015年 Animatious. All rights reserved.
//

#import "SCCatWaitingHUD.h"

@implementation SCCatWaitingHUD

+ (SCCatWaitingHUD *) sharedInstance
{
    static dispatch_once_t  onceToken;
    static SCCatWaitingHUD * sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SCCatWaitingHUD alloc] initWithFrame:CGRectMake(ScreenWidth/2.0f - (Global_animationSize * 4.0f)/2.0f, ScreenHeight/2.0f - (Global_animationSize * 4.0f)/2.0f, Global_animationSize * 4.0f, Global_animationSize * 4.0f)];
    });
    return sharedInstance;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.easeInDuration = 0.2f;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(statusBarOrientationChange:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
        self.backgroundWindow = [[UIWindow alloc]initWithFrame:self.frame];
        _backgroundWindow.windowLevel = UIWindowLevelStatusBar;
        _backgroundWindow.backgroundColor = [UIColor colorWithRed:75.0f/255.0f green:52.0f/255.0f blue:97.0f/255.0f alpha:0.7f];
        _backgroundWindow.layer.cornerRadius = 6.0f;
        _backgroundWindow.alpha = 0.0f;
        
        self.userInteractionEnabled = NO;
        _backgroundWindow.userInteractionEnabled = NO;
        self.isAnimating = NO;
        
        NSString *bundlePath = [[NSBundle bundleForClass:[SCCatWaitingHUD class]]
                                pathForResource:@"SCCatWaitingHUD" ofType:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
        
        CGFloat width =  Global_animationSize;
        self.faceView = [[UIImageView alloc]initWithFrame:CGRectMake(_backgroundWindow.width/2.0f - width/2.0f, _backgroundWindow.height/2.0f - width/2.0f, width, width)];
        _faceView.contentMode = UIViewContentModeScaleAspectFill;
        _faceView.backgroundColor = [UIColor clearColor];
        _faceView.image = [UIImage imageNamed:@"MAO@2x" inBundle:bundle compatibleWithTraitCollection:nil];
        [_backgroundWindow addSubview:_faceView];
        
        self.leftEye = [[UIView alloc]initWithFrame:CGRectMake(self.faceView.left + 8.0f, self.faceView.top + width/3.0f + 1.0f, 5.0f, 5.0f)];
        _leftEye.layer.masksToBounds = YES;
        _leftEye.layer.cornerRadius = 2.5f;
        _leftEye.backgroundColor = [UIColor blackColor];
        _leftEye.layer.anchorPoint = CGPointMake(1.7f, 1.3f);
        _leftEye.layer.position = CGPointMake(self.faceView.left + 13.5f,self.faceView.top + width/3.0f + 7.5f);
        [_backgroundWindow addSubview:_leftEye];
        
        self.rightEye = [[UIView alloc]initWithFrame:CGRectMake(self.leftEye.right + width/3.0f + 1.0f, self.faceView.top + width/3.0f + 1.0f, 5.0f, 5.0f)];
        _rightEye.layer.masksToBounds = YES;
        _rightEye.layer.cornerRadius = 2.5f;
        _rightEye.backgroundColor = [UIColor blackColor];
        _rightEye.layer.anchorPoint = CGPointMake(1.7f, 1.3f);
        _rightEye.layer.position = CGPointMake(self.faceView.right - 13.5f, self.faceView.top + width/3.0f + 7.5f);
        [_backgroundWindow addSubview:_rightEye];
        
        self.mouseView = [[UIImageView alloc]initWithFrame:CGRectMake(_backgroundWindow.width/2.0f - width * 1.25f, _backgroundWindow.height/2.0f - width * 1.25f, width * 2.5f, width * 2.5f)];
        _mouseView.contentMode = UIViewContentModeScaleAspectFill;
        _mouseView.backgroundColor = [UIColor clearColor];
        _mouseView.image = [UIImage imageNamed:@"mouse@2x" inBundle:bundle compatibleWithTraitCollection:nil];
        [_backgroundWindow addSubview:_mouseView];
    }
    return self;
}

- (void)statusBarOrientationChange:(NSNotification *)notification
{
    if(!_isAnimating)
    {
        // 若不在显示状态则不需要响应旋转
        return;
    }
    
    UIInterfaceOrientation oriention = [UIApplication sharedApplication].statusBarOrientation;
    
    CGFloat degree = 0.0f;
    switch (oriention) {
        case UIInterfaceOrientationLandscapeLeft:
        {
            if(self.previousOrientation == UIInterfaceOrientationLandscapeRight)
            {
                degree = -180.0f;
            }
            else if(self.previousOrientation == UIInterfaceOrientationPortrait)
            {
                degree = -90.0f;
            }
        }
            break;
        case UIInterfaceOrientationLandscapeRight:
        {
            if(self.previousOrientation == UIInterfaceOrientationLandscapeLeft)
            {
                degree = 180.0f;
            }
            else if(self.previousOrientation == UIInterfaceOrientationPortrait)
            {
                degree = 90.0f;
            }
        }
            break;
        case UIInterfaceOrientationPortrait:
        {
            if(self.previousOrientation == UIInterfaceOrientationLandscapeRight)
            {
                degree = -90.0f;
            }
            else if(self.previousOrientation == UIInterfaceOrientationLandscapeLeft)
            {
                degree = 90.0f;
            }
        }
            break;
        default:
            break;
    }
    
    self.previousOrientation = oriention;
    CGAffineTransform transform = _backgroundWindow.transform;
    transform = CGAffineTransformRotate(transform,  radians(degree));
    _backgroundWindow.transform = transform;
}

- (void)animateWithInteractionEnabled:(BOOL)enabled
{
    UIInterfaceOrientation oriention = [UIApplication sharedApplication].statusBarOrientation;
    self.previousOrientation = oriention;
    if(oriention == UIInterfaceOrientationPortrait)
    {
        _backgroundWindow.frame = CGRectMake(ScreenWidth/2.0f - (Global_animationSize * 4.0f)/2.0f, ScreenHeight/2.0f - (Global_animationSize * 4.0f)/2.0f, Global_animationSize * 4.0f, Global_animationSize * 4.0f);
    }
    else if(oriention == UIInterfaceOrientationLandscapeRight)
    {
        _backgroundWindow.frame = CGRectMake(ScreenHeight/2.0f - (Global_animationSize * 4.0f)/2.0f, ScreenWidth/2.0f - (Global_animationSize * 4.0f)/2.0f, Global_animationSize * 4.0f, Global_animationSize * 4.0f);
        CGAffineTransform transform = _backgroundWindow.transform;
        transform = CGAffineTransformRotate(transform,  radians(90.0f));
        _backgroundWindow.transform = transform;
    }
    else if(oriention == UIInterfaceOrientationLandscapeLeft)
    {
        _backgroundWindow.frame = CGRectMake(ScreenHeight/2.0f - (Global_animationSize * 4.0f)/2.0f, ScreenWidth/2.0f - (Global_animationSize * 4.0f)/2.0f, Global_animationSize * 4.0f, Global_animationSize * 4.0f);
        CGAffineTransform transform = _backgroundWindow.transform;
        transform = CGAffineTransformRotate(transform,  radians(-90.0f));
        _backgroundWindow.transform = transform;
    }
    
    self.userInteractionEnabled = !enabled;
    _backgroundWindow.userInteractionEnabled = !enabled;
    
    if(_isAnimating)
    {
        return;
    }
    [_backgroundWindow makeKeyAndVisible];
    
    [UIView animateWithDuration:_easeInDuration animations:^{
        _backgroundWindow.alpha = 1.0f;
    } completion:^(BOOL finished) {
        _isAnimating = YES;
        CABasicAnimation *rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        rotationAnimation.fromValue = [NSValue valueWithCATransform3D:getTransForm3DWithAngle(0.0f)];
        rotationAnimation.toValue = [NSValue valueWithCATransform3D:getTransForm3DWithAngle(radians(180.0f))];
        rotationAnimation.duration = 2.0f;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = HUGE_VALF;
        rotationAnimation.removedOnCompletion=NO;
        rotationAnimation.fillMode=kCAFillModeForwards;
        rotationAnimation.autoreverses = NO;
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        self.currentAnimation = rotationAnimation;
        
        [_mouseView.layer addAnimation:rotationAnimation forKey:@"rotate"];
        [_leftEye.layer addAnimation:rotationAnimation forKey:@"rotate"];
        [_rightEye.layer addAnimation:rotationAnimation forKey:@"rotate"];
    }];
}

- (void)animate
{
    [self animateWithInteractionEnabled:YES];
}

- (void)stop
{
    if(!_isAnimating)
    {
        return;
    }
    
    [UIView animateWithDuration:_easeInDuration animations:^{
        _backgroundWindow.alpha = 0.0f;
    } completion:^(BOOL finished) {
        CGAffineTransform transform = CGAffineTransformIdentity;
        //transform = CGAffineTransformRotate(transform,  radians(0.0f));
        _backgroundWindow.transform = transform;
        
        _isAnimating = NO;
        _backgroundWindow.hidden = YES;
        [_mouseView.layer removeAnimationForKey:@"rotate"];
        [_leftEye.layer removeAnimationForKey:@"rotate"];
        [_rightEye.layer removeAnimationForKey:@"rotate"];
    }];
}
@end
