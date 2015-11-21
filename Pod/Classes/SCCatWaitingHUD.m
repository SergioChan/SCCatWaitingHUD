//
//  SCCatWaitingHUD.m
//  SCCatWaitingHUD
//
//  Created by Yh c on 15/11/13.
//  Copyright © 2015年 Animatious. All rights reserved.
//

#import "SCCatWaitingHUD.h"
#import <CoreText/CoreText.h>

@interface SCCatWaitingHUD()
{
    NSTimer *timer;
}
@property (nonatomic, strong) UIView *leftEye;
@property (nonatomic, strong) UIView *rightEye;

@property (nonatomic, strong) UIView *leftEyeCover;
@property (nonatomic, strong) UIView *rightEyeCover;

@property (nonatomic) UIInterfaceOrientation previousOrientation;

// Warning: The parameters below are not recommended to modify by user at runtime.

/**
 *  Time duration for HUD display and disappear.
 */
@property (nonatomic) CGFloat easeInDuration;

/**
 *  Time duration for each loop.
 */
@property (nonatomic) CGFloat animationDuration;

@end

@implementation SCCatWaitingHUD

+ (SCCatWaitingHUD *) sharedInstance
{
    static dispatch_once_t  onceToken;
    static SCCatWaitingHUD * sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SCCatWaitingHUD alloc] initWithFrame:CGRectMake(0.0f,0.0f,ScreenWidth,ScreenHeight)];
    });
    return sharedInstance;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        // Recommended duration would be 2.0 seconds. Represents half of the time of each loop.
        self.animationDuration = 2.0f;
        self.easeInDuration = self.animationDuration * 0.25f;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(statusBarOrientationChange:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
        
        [self initSubViews];
    }
    return self;
}

/**
 *  初始化所有子视图
 */
- (void)initSubViews
{
    self.backgroundWindow = [[UIWindow alloc]initWithFrame:self.frame];
    _backgroundWindow.windowLevel = UIWindowLevelStatusBar;
    _backgroundWindow.backgroundColor = [UIColor clearColor];
    _backgroundWindow.alpha = 0.0f;
    self.title = @"Loading...";
    
    self.blurView = [[UIVisualEffectView alloc]initWithFrame:self.frame];
    _blurView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    [_backgroundWindow addSubview:_blurView];
    
    self.userInteractionEnabled = NO;
    _backgroundWindow.userInteractionEnabled = NO;
    self.isAnimating = NO;
    
    self.indicatorView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2.0f - (SCCatWaiting_animationSize * 4.0f)/2.0f, ScreenHeight/2.0f - (SCCatWaiting_animationSize * 4.0f)/2.0f, SCCatWaiting_animationSize * 4.0f, SCCatWaiting_animationSize * 4.0f)];
    _indicatorView.backgroundColor = SCCatWaiting_catPurple;
    _indicatorView.layer.cornerRadius = 6.0f;
    _indicatorView.alpha = 0.0f;
    [_backgroundWindow addSubview:_indicatorView];
    
    NSString *bundlePath = [[NSBundle bundleForClass:[SCCatWaitingHUD class]]
                            pathForResource:@"SCCatWaitingHUD" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    CGFloat width =  SCCatWaiting_animationSize;
    self.faceView = [[UIImageView alloc]initWithFrame:CGRectMake(_indicatorView.width/2.0f - width/2.0f, _indicatorView.height/2.0f - width/2.0f - 20.0f, width, width)];
    _faceView.contentMode = UIViewContentModeScaleAspectFill;
    _faceView.backgroundColor = [UIColor clearColor];
    _faceView.image = [UIImage imageNamed:@"MAO@2x" inBundle:bundle compatibleWithTraitCollection:nil];
    [_indicatorView addSubview:_faceView];
    
    self.leftEye = [[UIView alloc]initWithFrame:CGRectMake(self.faceView.left + 8.0f, self.faceView.top + width/3.0f + 1.0f, 5.0f, 5.0f)];
    _leftEye.layer.masksToBounds = YES;
    _leftEye.layer.cornerRadius = 2.5f;
    _leftEye.backgroundColor = [UIColor blackColor];
    _leftEye.layer.anchorPoint = CGPointMake(1.5f, 1.5f);
    _leftEye.layer.position = CGPointMake(self.faceView.left + 13.5f,self.faceView.top + width/3.0f + 7.5f);
    [_indicatorView addSubview:_leftEye];
    
    // Note : 比例是从sketch中算出来的
    self.leftEyeCover = [[UIView alloc]initWithFrame:CGRectMake(self.faceView.left + width / 15.0f, self.leftEye.top - 5.0f - width/8.0f, width * 0.42f, width/10.0f)];
    _leftEyeCover.backgroundColor = SCCatWaiting_leftFaceGray;
    _leftEyeCover.layer.anchorPoint = CGPointMake(0.5, 0.0f);
    [_indicatorView addSubview:_leftEyeCover];
    
    self.rightEye = [[UIView alloc]initWithFrame:CGRectMake(self.leftEye.right + width/3.0f + 1.0f, self.faceView.top + width/3.0f + 1.0f, 5.0f, 5.0f)];
    _rightEye.layer.masksToBounds = YES;
    _rightEye.layer.cornerRadius = 2.5f;
    _rightEye.backgroundColor = [UIColor blackColor];
    _rightEye.layer.anchorPoint = CGPointMake(1.5f, 1.5f);
    _rightEye.layer.position = CGPointMake(self.faceView.right - 13.5f, self.faceView.top + width/3.0f + 7.5f);
    [_indicatorView addSubview:_rightEye];
    
    self.rightEyeCover = [[UIView alloc]initWithFrame:CGRectMake(self.faceView.left + width * 0.52f, self.rightEye.top - 5.0f - width/8.0f, width * 0.42f, width/10.0f)];
    _rightEyeCover.backgroundColor = SCCatWaiting_rightFaceGray;
    _rightEyeCover.layer.anchorPoint = CGPointMake(0.5, 0.0f);
    [_indicatorView addSubview:_rightEyeCover];
    
    self.mouseView = [[UIImageView alloc]initWithFrame:CGRectMake(_indicatorView.width/2.0f - width * 1.25f, _indicatorView.height/2.0f - width * 1.25f - 20.0f, width * 2.5f, width * 2.5f)];
    _mouseView.contentMode = UIViewContentModeScaleAspectFill;
    _mouseView.backgroundColor = [UIColor clearColor];
    _mouseView.image = [UIImage imageNamed:@"mouse@2x" inBundle:bundle compatibleWithTraitCollection:nil];
    [_indicatorView addSubview:_mouseView];
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0f,self.mouseView.bottom + 15.0f,0.0f,25.0f)];
    //_contentLabel.text = self.title;
    _contentLabel.textColor = [UIColor whiteColor];
    _contentLabel.font = [UIFont systemFontOfSize:20.0f];
    _contentLabel.lineBreakMode = NSLineBreakByClipping;
    _contentLabel.numberOfLines = 1;
    _contentLabel.alpha = 1.0f;
    // Set a limitation here.
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    [_indicatorView addSubview:_contentLabel];
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
    CGAffineTransform transform = _indicatorView.transform;
    transform = CGAffineTransformRotate(transform,  radians(degree));
    _indicatorView.transform = transform;
}

- (void)animateWithInteractionEnabled:(BOOL)enabled title:(NSString *)title duration:(CGFloat)duration
{
    if(!title)
        self.title = title;
    self.animationDuration = duration / 2.0f;
    [self animateWithInteractionEnabled:enabled];
}

- (void)animateWithInteractionEnabled:(BOOL)enabled title:(NSString *)title
{
    if(!title)
        self.title = title;
    [self animateWithInteractionEnabled:enabled];
}

- (void)animateWithInteractionEnabled:(BOOL)enabled
{
    UIInterfaceOrientation oriention = [UIApplication sharedApplication].statusBarOrientation;
    self.previousOrientation = oriention;
    if(oriention == UIInterfaceOrientationPortrait)
    {
        _blurView.frame = CGRectMake(0.0f, 0.0f, ScreenWidth, ScreenHeight);
        _indicatorView.frame = CGRectMake(ScreenWidth/2.0f - (SCCatWaiting_animationSize * 4.0f)/2.0f, ScreenHeight/2.0f - (SCCatWaiting_animationSize * 4.0f)/2.0f, SCCatWaiting_animationSize * 4.0f, SCCatWaiting_animationSize * 4.0f);
    }
    else if(oriention == UIInterfaceOrientationLandscapeRight)
    {
        _blurView.frame = CGRectMake(0.0f, 0.0f, ScreenHeight, ScreenWidth);
        _indicatorView.frame = CGRectMake(ScreenHeight/2.0f - (SCCatWaiting_animationSize * 4.0f)/2.0f, ScreenWidth/2.0f - (SCCatWaiting_animationSize * 4.0f)/2.0f, SCCatWaiting_animationSize * 4.0f, SCCatWaiting_animationSize * 4.0f);
        CGAffineTransform transform = _indicatorView.transform;
        transform = CGAffineTransformRotate(transform,  radians(90.0f));
        _indicatorView.transform = transform;
    }
    else if(oriention == UIInterfaceOrientationLandscapeLeft)
    {
        _blurView.frame = CGRectMake(0.0f, 0.0f, ScreenHeight, ScreenWidth);
        _indicatorView.frame = CGRectMake(ScreenHeight/2.0f - (SCCatWaiting_animationSize * 4.0f)/2.0f, ScreenWidth/2.0f - (SCCatWaiting_animationSize * 4.0f)/2.0f, SCCatWaiting_animationSize * 4.0f, SCCatWaiting_animationSize * 4.0f);
        CGAffineTransform transform = _indicatorView.transform;
        transform = CGAffineTransformRotate(transform,  radians(-90.0f));
        _indicatorView.transform = transform;
    }
    
    [self configureContentLabelText];
    
    self.userInteractionEnabled = !enabled;
    _backgroundWindow.userInteractionEnabled = !enabled;
    
    if(_isAnimating)
    {
        return;
    }
    
    _isAnimating = YES;
    [_backgroundWindow makeKeyAndVisible];
    timer = [NSTimer scheduledTimerWithTimeInterval:self.animationDuration * 2.0f  target:self selector:@selector(timerUpdate:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [timer fire];
    
    [UIView animateWithDuration:_easeInDuration animations:^{
        _backgroundWindow.alpha = 1.0f;
        _indicatorView.alpha = 1.0f;
    } completion:^(BOOL finished) {
    }];
    
    [_leftEyeCover.layer addAnimation:[self scaleAnimation] forKey:@"scale"];
    [_rightEyeCover.layer addAnimation:[self scaleAnimation] forKey:@"scale"];
    
    [self performSelector:@selector(test) withObject:nil afterDelay:self.animationDuration * 0.25f];
}

- (void)test
{
    [_mouseView.layer addAnimation:[self rotationAnimation] forKey:@"rotate"];
    [_leftEye.layer addAnimation:[self rotationAnimation] forKey:@"rotate"];
    [_rightEye.layer addAnimation:[self rotationAnimation] forKey:@"rotate"];
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
    
    [timer invalidate];
    timer = nil;
    self.contentLabel.attributedText = nil;
    self.contentLabel.frame = CGRectMake(20.0f,self.mouseView.bottom + 15.0f,0.0f,25.0f);
    self.contentLabel.alpha = 1.0f;
    [self.contentLabel.layer removeAllAnimations];
    // 一定要在结束的时候清空这个layer所附带的所有动画，否则会在下一次出现的时候重新显示未完成的动画
    
    [UIView animateWithDuration:_easeInDuration animations:^{
        _backgroundWindow.alpha = 0.0f;
        _indicatorView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        CGAffineTransform transform = CGAffineTransformIdentity;
        //transform = CGAffineTransformRotate(transform,  radians(0.0f));
        _indicatorView.transform = transform;
        _isAnimating = NO;
        _backgroundWindow.hidden = YES;
        
        // According to Apple Doc : This is a convenience method to make the receiver the main window and displays it in front of other windows at the same window level or lower. You can also hide and reveal a window using the inherited hidden property of UIView.
        [_mouseView.layer removeAnimationForKey:@"rotate"];
        [_leftEye.layer removeAnimationForKey:@"rotate"];
        [_rightEye.layer removeAnimationForKey:@"rotate"];
        
        [_leftEyeCover.layer removeAnimationForKey:@"scale"];
        [_rightEyeCover.layer removeAnimationForKey:@"scale"];
    }];
}

/**
 *  处理Label中的文本间距
 */
- (void)configureContentLabelText
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.title];
    long number = 5;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString length])];
    CFRelease(num);
    
    self.contentLabel.attributedText = attributedString;
}

- (void)timerUpdate:(id)sender
{
    [UIView animateWithDuration:self.animationDuration * 1.6f delay:0.0f options:UIViewAnimationOptionCurveEaseIn  animations:^{
        self.contentLabel.width = _indicatorView.width - 40.0f;
        self.contentLabel.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.contentLabel.alpha = 1.0f;
        self.contentLabel.width = 0.0f;
    }];
}

- (CABasicAnimation *)rotationAnimation
{
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotationAnimation.fromValue = [NSValue valueWithCATransform3D:getTransForm3DWithAngle(0.0f)];
    rotationAnimation.toValue = [NSValue valueWithCATransform3D:getTransForm3DWithAngle(radians(180.0f))];
    rotationAnimation.duration = self.animationDuration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.removedOnCompletion=NO;
    rotationAnimation.fillMode=kCAFillModeForwards;
    rotationAnimation.autoreverses = NO;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    return rotationAnimation;
}

- (CAAnimationGroup *)scaleAnimation
{
    // 眼皮和眼珠需要确定一个运动时间曲线
    CABasicAnimation *scaleAnimation;
    scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 3.0, 1.0)];
    scaleAnimation.duration = self.animationDuration;
    scaleAnimation.cumulative = YES;
    scaleAnimation.repeatCount = 1;
    scaleAnimation.removedOnCompletion= NO;
    scaleAnimation.fillMode=kCAFillModeForwards;
    scaleAnimation.autoreverses = NO;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.2:0.0 :0.8 :1.0];
    scaleAnimation.speed = 1.0f;
    scaleAnimation.beginTime = 0.0f;

    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = self.animationDuration;
    group.repeatCount = HUGE_VALF;
    group.removedOnCompletion= NO;
    group.fillMode=kCAFillModeForwards;
    group.autoreverses = YES;
    group.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.2:0.0:0.8 :1.0];
    
    group.animations = [NSArray arrayWithObjects:scaleAnimation, nil];
    return group;
}

@end
