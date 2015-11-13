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

@property (nonatomic, strong) UIImageView *faceView;
@property (nonatomic, strong) UIImageView *mouseView;

@property (nonatomic, strong) UIView *leftEye;
@property (nonatomic, strong) UIView *rightEye;

@property (nonatomic) BOOL isAnimating;

- (void)animate;
- (void)stop;
@end
