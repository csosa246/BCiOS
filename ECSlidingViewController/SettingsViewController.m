//
//  UnderRightViewController.m
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController()
@property (nonatomic, assign) CGFloat peekLeftAmount;
@end

@implementation SettingsViewController
@synthesize peekLeftAmount;
@synthesize token,responseData,alert,ble,alertScanningDevices;
@synthesize currentRSSI;
@synthesize rssiUILabel;
@synthesize peripheralDeviceArray;
@synthesize editStateEnabled;
@synthesize backgroundImage;
@synthesize scrollView;

int i;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] beginAdvertising];
    
    self.peekLeftAmount = 40.0f;
    [self.slidingViewController setAnchorLeftPeekAmount:self.peekLeftAmount];
    self.slidingViewController.underRightWidthLayout = ECVariableRevealWidth;
    
    //NOTE THAT THIS WILL DESTROY THE PERIPHERALS ABILITY TO BROADCAST
    
//    ble = [[BLE alloc] init];
//    [ble controlSetup:1];
//    ble.delegate = self;
    
    //Initiatilizing the peripheral array
    peripheralDeviceArray = [[NSMutableArray alloc] init];
    
    //Edit state
    editStateEnabled = NO;
    [self loadDesign];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"View did appear called");
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320, 2000)];
}

- (void) awakeFromNib{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(underRightWillAppear:) name:ECSlidingViewUnderRightWillAppear object:self.slidingViewController];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topDidReset:) name:ECSlidingViewTopDidReset object:self.slidingViewController];
}

-(void) loadDesign{
    //Background
    UIImage *image = [UIImage imageNamed:@"still2.png"];
    DesignLibaryAdapter *im = [[DesignLibaryAdapter alloc] init];
    UIImage *imageToBeBlurred = [im blur:image];
    UIColor *background = [[UIColor alloc] initWithPatternImage:imageToBeBlurred];
    self.view.backgroundColor = background;
    //Fonts
    [im setFonts:positionLabel];
    [im setFonts:settingsLabel];
    [im setFonts:canaryLabel];
    [im setFonts:socialNetworkLabel];
}

- (void)underRightWillAppear:(NSNotification *)notification{
    NSLog(@"under right will appear");
}
- (void)topDidReset:(NSNotification *)notification{
    //Not so sure about whats going on here....
    NSLog(@"top did reset");
    editStateEnabled = YES;
    [self didClickEdit:nil];
}

- (void) bleDidReceivePeripherals:(NSMutableArray *)peripherals{
    
}

-(void) bleDidReceivePeripheralAdvertisementData:(NSNumber *)rssi uuid:(NSString *)uuid {
    NSString *rssiText = [NSString stringWithFormat:@"%@",rssi];
    Peripheral *peripheralDevice = [[Peripheral alloc] init];
    [peripheralDevice setUuid:uuid];
    [peripheralDevice setRssi:rssi];
    [peripheralDeviceArray addObject:peripheralDevice];
}

- (IBAction)didPressRegister:(id)sender{
    [self alert:YES message:@"Please hold Canary up to device and wait 5 seconds..." addButtonWithTitle:NO];
    [ble findBLEPeripherals:1];
}

-(void) bleDidStopScanning{
    i++;
    if(i<5){
        [ble findBLEPeripherals:1];
    }else{
        //Reset the count
        i=0;
        //Do some comparitive data analysis
        NSNumber *greatestRssi = [[NSNumber alloc] initWithDouble:-9999];
        int indexOfGreatestRssi = 0;
        for(int j = 0; j<peripheralDeviceArray.count; j ++){
            Peripheral *peripheral = [peripheralDeviceArray objectAtIndex:j];
            NSNumber *rssi = [peripheral rssi];
            //NSLog([NSString stringWithFormat:@"%@",rssi]);
            if ([rssi intValue] > [greatestRssi intValue]){
                greatestRssi = rssi;
                indexOfGreatestRssi = j;
            }
        }
        [self alert:NO message:nil addButtonWithTitle:NO];

        if(peripheralDeviceArray.count!=0 && ([greatestRssi intValue] > -45) && ([greatestRssi intValue] <0)){
            Peripheral *peripheralToConnect = [peripheralDeviceArray objectAtIndex:indexOfGreatestRssi];
            NSString *closestPeripheral = [peripheralToConnect uuid];
            //NSLog(closestPeripheral);
            [self alert:YES message:closestPeripheral addButtonWithTitle:YES];
        }else{
            [self alert:YES message:@"No devices found" addButtonWithTitle:YES];
        }
        [peripheralDeviceArray removeAllObjects];
    }
}

- (IBAction)didPressSignup:(id)sender {
    [self performSegueWithIdentifier:@"mycanary2linkedinauth" sender:self];
}

-(void)alert:(BOOL)showAlert message:(NSString*)message addButtonWithTitle:(BOOL)button{
    if(showAlert){
        alertScanningDevices = [[UIAlertView alloc] initWithTitle:message message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        if(button){
            [alertScanningDevices addButtonWithTitle:@"Ok"];
        }
        [alertScanningDevices show];
    }else{
        [alertScanningDevices dismissWithClickedButtonIndex:0 animated:YES];
    }
}
- (IBAction)didClickEdit:(id)sender {
    if(editStateEnabled == YES){
        editStateEnabled = NO;
        [self transitionView:registerCanaryButton isHidden:YES];
        [self transitionView:findCanaryButton isHidden:NO];
        [self transitionView:linkedInLinkButton isHidden:YES];
        [self transitionView:linkedInSwitch isHidden:NO];
        [self transitionView:facebookLinkButton isHidden:YES];
        [self transitionView:facebookSwitch isHidden:NO];
        editButton.title = @"Edit  ";
    }else{
        editStateEnabled = YES;
        [self transitionView:registerCanaryButton isHidden:NO];
        [self transitionView:findCanaryButton isHidden:YES];
        [self transitionView:linkedInLinkButton isHidden:NO];
        [self transitionView:linkedInSwitch isHidden:YES];
        [self transitionView:facebookLinkButton isHidden:NO];
        [self transitionView:facebookSwitch isHidden:YES];
        editButton.title = @"Done  ";
    }
}

- (IBAction)didClickBroadcastSwitch:(id)sender {
    if(broadcastSwitch.on){
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] resumeAdvertising];
    }else{
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] pauseAdvertising];
    }
}

-(void) transitionView:(UIView *)view isHidden:(BOOL)isHidden{
    [UIView transitionWithView:view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:NULL completion:NULL];
    view.hidden = isHidden;
}
@end
