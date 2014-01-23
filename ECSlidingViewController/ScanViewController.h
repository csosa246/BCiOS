//
//  SampleTableViewController.h
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 2/13/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ECSlidingViewController.h"
#import "BeaconAdapter.h"
//#import "BLEDevice.h"
#import "ScanHTTPAdapter.h"
//#import "Peripheral.h"


//@protocol BluetoothActivationDelegate
//
//-(void)startScanning;
//
//@end

@interface ScanViewController : UITableViewController <CLLocationManagerDelegate,BeaconAdapterDelegate,ScanHTTPDelegate>

//@property (strong,nonatomic) UIAlertView *alertScanningDevices;
//@property (strong,nonatomic) NSMutableData *responseData;
@property(strong,nonatomic) UIRefreshControl *refresh;
@property (strong, nonatomic) ScanHTTPAdapter *scanHttp;
@property (strong, nonatomic) CLBeaconRegion *myBeaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) NSMutableDictionary *beaconsDictionary;
@property (strong, nonatomic) BeaconAdapter *beaconAdapter;

-(void) removeViewController;
- (IBAction)revealMenu:(id)sender;
- (IBAction)revealUnderRight:(id)sender;
@end
