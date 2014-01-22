/*
 File: ALRangingViewController.m
 Abstract: View controller that illustrates how to start and stop ranging for a beacon region.
 */

#import "BeaconAdapter.h"
#import "ALDefaults.h"

@implementation BeaconAdapter
@synthesize beaconArray,locationManager,beaconRegion;

-(void) controlSetup:(int)s{
    beaconArray = [[NSMutableDictionary alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    // Initialize location manager and set ourselves as the delegate
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // Create a NSUUID with the same UUID as the broadcasting beacon
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];
    //    // Setup a new region with that UUID and same identifier as the broadcasting beacon
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                 identifier:@"com.appcoda.testregion"];
    // Tell location manager to start ranging for the beacon region
//    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void) startRangingBeacons{
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void) stopRandingBeacons{
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    NSLog(@"manager was called");
    // CoreLocation will call this delegate method at 1 Hz with updated range information.
    // Beacons will be categorized and displayed by proximity.
    [beaconArray removeAllObjects];
    NSArray *unknownBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityUnknown]];
    if([unknownBeacons count])
        [beaconArray setObject:unknownBeacons forKey:[NSNumber numberWithInt:CLProximityUnknown]];
    
    NSArray *immediateBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityImmediate]];
    if([immediateBeacons count])
        [beaconArray setObject:immediateBeacons forKey:[NSNumber numberWithInt:CLProximityImmediate]];
    
    NSArray *nearBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityNear]];
    if([nearBeacons count])
        [beaconArray setObject:nearBeacons forKey:[NSNumber numberWithInt:CLProximityNear]];
    
    NSArray *farBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityFar]];
    if([farBeacons count])
        [beaconArray setObject:farBeacons forKey:[NSNumber numberWithInt:CLProximityFar]];
    
    [self.delegate didReceiveBeaconArray:beaconArray];
    
//    [self.tableView reloadData];
}
@end
