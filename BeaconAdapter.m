/*
 File: ALRangingViewController.m
 Abstract: View controller that illustrates how to start and stop ranging for a beacon region.
 */

#import "BeaconAdapter.h"
#import "ALDefaults.h"

@implementation BeaconAdapter
@synthesize beaconDictionary,locationManager,beaconRegion,shouldContinuouslyScanForBeacons;

-(void) controlSetup:(int)s{
    beaconDictionary = [[NSMutableDictionary alloc] init];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];
    beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.appcoda.testregion"];
    shouldContinuouslyScanForBeacons = NO;
}

-(void) setShouldContinuouslyScanForBeacons:(BOOL)scanForBeacons{
    NSLog(@"SETTING");
    shouldContinuouslyScanForBeacons = !shouldContinuouslyScanForBeacons;
}

-(void) startRangingBeacons{
    [self.locationManager startRangingBeaconsInRegion:beaconRegion];
}

-(void) stopRangingBeacons{
    [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    NSLog(@"manager was called");
    // CoreLocation will call this delegate method at 1 Hz with updated range information.
    // Beacons will be categorized and displayed by proximity.
    [beaconDictionary removeAllObjects];
    NSArray *unknownBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityUnknown]];
    if([unknownBeacons count])
        [beaconDictionary setObject:unknownBeacons forKey:[NSNumber numberWithInt:CLProximityUnknown]];
    
    NSArray *immediateBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityImmediate]];
    if([immediateBeacons count])
        [beaconDictionary setObject:immediateBeacons forKey:[NSNumber numberWithInt:CLProximityImmediate]];
    
    NSArray *nearBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityNear]];
    if([nearBeacons count])
        [beaconDictionary setObject:nearBeacons forKey:[NSNumber numberWithInt:CLProximityNear]];
    
    NSArray *farBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityFar]];
    if([farBeacons count])
        [beaconDictionary setObject:farBeacons forKey:[NSNumber numberWithInt:CLProximityFar]];
    [self.delegate didReceiveBeaconDictionary:beaconDictionary];
    if(!shouldContinuouslyScanForBeacons){
        [self stopRangingBeacons];
    }
}
@end
