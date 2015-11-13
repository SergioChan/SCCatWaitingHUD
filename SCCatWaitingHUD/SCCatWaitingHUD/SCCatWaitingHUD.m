//
//  SCCatWaitingHUD.m
//  SCCatWaitingHUD
//
//  Created by Yh c on 15/11/13.
//  Copyright © 2015年 Animatious. All rights reserved.
//

#import "SCCatWaitingHUD.h"

@implementation SCCatWaitingHUD

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.isAnimating = NO;
        
        CGFloat width = 50.0f;
        self.faceView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width/2.0f - width/2.0f, self.height/2.0f - width/2.0f, width, width)];
        _faceView.contentMode = UIViewContentModeScaleAspectFill;
        _faceView.backgroundColor = [UIColor clearColor];
        _faceView.image = [UIImage imageNamed:@"CatFace"];
        [self addSubview:_faceView];
        
        self.leftEye = [[UIView alloc]initWithFrame:CGRectMake(self.faceView.left + 8.0f, self.faceView.top + width/3.0f + 1.0f, 5.0f, 5.0f)];
        _leftEye.layer.masksToBounds = YES;
        _leftEye.layer.cornerRadius = 2.5f;
        _leftEye.backgroundColor = [UIColor blackColor];
        _leftEye.layer.anchorPoint = CGPointMake(1.7f, 1.3f);
        _leftEye.layer.position = CGPointMake(self.faceView.left + 13.5f,self.faceView.top + width/3.0f + 7.5f);
        [self addSubview:_leftEye];
        
        self.rightEye = [[UIView alloc]initWithFrame:CGRectMake(self.leftEye.right + width/3.0f + 1.0f, self.faceView.top + width/3.0f + 1.0f, 5.0f, 5.0f)];
        _rightEye.layer.masksToBounds = YES;
        _rightEye.layer.cornerRadius = 2.5f;
        _rightEye.backgroundColor = [UIColor blackColor];
        _rightEye.layer.anchorPoint = CGPointMake(1.7f, 1.3f);
        _rightEye.layer.position = CGPointMake(self.faceView.right - 13.5f, self.faceView.top + width/3.0f + 7.5f);
        [self addSubview:_rightEye];
        
        self.mouseView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width/2.0f - width * 1.5f, self.height/2.0f - width * 1.5f, width * 3.0f, width * 3.0f)];
        _mouseView.contentMode = UIViewContentModeScaleAspectFill;
        _mouseView.backgroundColor = [UIColor clearColor];
        _mouseView.image = [UIImage imageNamed:@"Mouse"];
        [self addSubview:_mouseView];
    }
    return self;
}

- (void)animate
{
    if(_isAnimating)
    {
        return;
    }
    
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
    rotationAnimation.delegate = self;
    
    [_mouseView.layer addAnimation:rotationAnimation forKey:@"rotate"];
    [_leftEye.layer addAnimation:rotationAnimation forKey:@"rotate"];
    [_rightEye.layer addAnimation:rotationAnimation forKey:@"rotate"];
}

- (void)animationDidStart:(CAAnimation *)anim
{
     _isAnimating = YES;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    _isAnimating = NO;
}

- (void)stop
{
    if(!_isAnimating)
    {
        return;
    }
    
    [_mouseView.layer removeAnimationForKey:@"rotate"];
    [_leftEye.layer removeAnimationForKey:@"rotate"];
    [_rightEye.layer removeAnimationForKey:@"rotate"];
}
@end
