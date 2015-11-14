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
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(![SCCatWaitingHUD sharedInstance].isAnimating)
    {
        [[SCCatWaitingHUD sharedInstance] animate];
        self.hintLabel.text = @"Tap to stop";
    }
    else
    {
        [[SCCatWaitingHUD sharedInstance] stop];
        self.hintLabel.text = @"Tap to animate";
    }
     
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
