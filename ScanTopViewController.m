//
//  ScanTopViewController.m
//  ECSlidingViewController
//
//  Created by Crae Sosa on 10/17/13.

#import "ScanTopViewController.h"

@implementation ScanTopViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // shadowPath, shadowOffset
    self.view.layer.shadowOpacity = 0.50f;
    self.view.layer.shadowRadius = 5.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    if (![self.slidingViewController.underRightViewController isKindOfClass:[SettingsViewController class]]) {
        self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UnderRight"];
    }
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}
@end