//
//  SCViewController.m
//  SCCatWaitingHUD
//
//  Created by SergioChan on 11/14/2015.
//  Copyright (c) 2015 SergioChan. All rights reserved.
//

#import "SCViewController.h"
#import "SCCatWaitingHUD.h"

@interface SCViewController ()
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(![SCCatWaitingHUD sharedInstance].isAnimating)
    {
        [[SCCatWaitingHUD sharedInstance] animateWithInteractionEnabled:YES];
    }
    else
    {
        [[SCCatWaitingHUD sharedInstance] stop];
    }
}

// For issue #5
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    if(![SCCatWaitingHUD sharedInstance].isAnimating)
//    {
//        [[SCCatWaitingHUD sharedInstance] animateWithInteractionEnabled:YES];
//    }
//    else
//    {
//        [[SCCatWaitingHUD sharedInstance] stop];
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
