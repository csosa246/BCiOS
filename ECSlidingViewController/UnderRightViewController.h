//
//  UnderRightViewController.h
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ECSlidingViewController.h"
#import "BLE.h"
#import "Peripheral.h"
#import "DesignLibaryModel.h"
#import "AppDelegate.h"


@interface UnderRightViewController : UIViewController<BLEDelegate>{
    
    IBOutlet UIButton *registerCanaryButton;
    
    IBOutlet UIButton *findCanaryButton;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *positionLabel;
    
    IBOutlet UILabel *settingsLabel;
    IBOutlet UILabel *canaryLabel;
    IBOutlet UILabel *socialNetworkLabel;
    IBOutlet UIBarButtonItem *editButton;
    IBOutlet UIButton *linkedInLinkButton;
    IBOutlet UISwitch *linkedInSwitch;
    IBOutlet UIButton *facebookLinkButton;
    IBOutlet UISwitch *facebookSwitch;
    
    IBOutlet UISwitch *broadcastSwitch;
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;



@property BOOL editStateEnabled;

@property (strong,nonatomic) NSString *token;
@property (strong,nonatomic) UIAlertView *alertScanningDevices;
@property (strong,nonatomic) NSMutableData *responseData;
@property (strong,nonatomic) UIAlertView *alert;
@property (strong, nonatomic) BLE *ble;
@property (strong,nonatomic) NSNumber *currentRSSI;
@property (weak, nonatomic) IBOutlet UILabel *rssiUILabel;
@property (strong,nonatomic) NSMutableArray *peripheralDeviceArray;
- (IBAction)didClickEdit:(id)sender;
- (IBAction)didClickBroadcastSwitch:(id)sender;

@end
