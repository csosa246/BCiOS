//
//  SampleTableViewController.h
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 2/13/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "BLE.h"
#import "BLEDevice.h"
#import "ScanHTTPModel.h"
#import "Peripheral.h"


@protocol BluetoothActivationDelegate

-(void)startScanning;

@end


@interface SampleTableViewController : UITableViewController <UITableViewDataSource,BLEDelegate,ScanHTTPDelegate>{
}


@property (strong,nonatomic) UIAlertView *alertScanningDevices;
@property (strong,nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) BLE *ble;
@property(strong,nonatomic) UIRefreshControl *refresh;
@property (strong, nonatomic) ScanHTTPModel *scanHttp;

-(void) removeViewController;

- (IBAction)revealMenu:(id)sender;

- (IBAction)revealUnderRight:(id)sender;



@end
