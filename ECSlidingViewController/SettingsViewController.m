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
@synthesize token,responseData,alert,alertScanningDevices;
@synthesize currentRSSI;
@synthesize rssiUILabel;
@synthesize editStateEnabled;
@synthesize backgroundImage;
@synthesize scrollView;
@synthesize beaconAdapter;

int i;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.peekLeftAmount = 40.0f;
    [self.slidingViewController setAnchorLeftPeekAmount:self.peekLeftAmount];
    self.slidingViewController.underRightWidthLayout = ECVariableRevealWidth;
    
    beaconAdapter = [[BeaconAdapter alloc] init];
    [beaconAdapter controlSetup:1];
    [beaconAdapter setShouldContinuouslyScanForBeacons:YES];
    beaconAdapter.delegate = self;
    
    //Edit state
    editStateEnabled = NO;
    [self loadDesign];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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


- (IBAction)didPressRegister:(id)sender{
    [beaconAdapter startRangingBeacons];
    [beaconAdapter setShouldContinuouslyScanForBeacons:YES];
}

-(void) bleDidFindPeripheralToRegister:(NSString *)manufactureData{
    [self alert:YES message:manufactureData addButtonWithTitle:YES];
}

-(void) bleDidNotFindPeripheralToRegister:(NSString *)message{
    [self alert:YES message:message addButtonWithTitle:YES];
}

- (IBAction)didPressSignup:(id)sender {
    [self performSegueWithIdentifier:@"mycanary2linkedinauth" sender:self];
}

-(void) didReceiveBeaconDictionary:(NSMutableDictionary *)beaconArray{
//    NSLog(@"I GOT YO SHIT YO");
    NSMutableString *beaconsToIdentify = [NSMutableString string];
    for(int i = 0; i<beaconArray.count; i ++){
        NSNumber *sectionKey = [[beaconArray allKeys] objectAtIndex:i];
        CLBeacon *beacon = [[beaconArray objectForKey:sectionKey] objectAtIndex:0];
        
        NSString *accuracy = [NSString stringWithFormat:@"%.2fm",beacon.accuracy];
        NSLog(accuracy);
    }
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

-(void) transitionView:(UIView *)view isHidden:(BOOL)isHidden{
    [UIView transitionWithView:view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:NULL completion:NULL];
    view.hidden = isHidden;
}
@end
