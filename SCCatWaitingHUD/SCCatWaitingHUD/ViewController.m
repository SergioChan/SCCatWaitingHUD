//
//  ViewController.m
//  SCCatWaitingHUD
//
//  Created by Yh c on 15/11/13.
//  Copyright © 2015年 Animatious. All rights reserved.
//

#import "ViewController.h"
#import "SCCatWaitingHUD.h"

@interface ViewController ()

@property (nonatomic, strong) SCCatWaitingHUD *hudView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Global_catPurple;
    // Do any additional setup after loading the view, typically from a nib.
    self.hudView = [[SCCatWaitingHUD alloc]initWithFrame:CGRectMake(0.0f, 0.0f, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_hudView];
//    [view animate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(!_hudView.isAnimating)
    {
        [_hudView animate];
    }
    else
    {
        [_hudView stop];
    }
     
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
