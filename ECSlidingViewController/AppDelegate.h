//
//  AppDelegate.h
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "ECSlidingViewController.h"
#import "ScanViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;


@end
