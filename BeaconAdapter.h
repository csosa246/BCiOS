//
//  IBeaconAdapter.h
//  Bluecast
//
//  Created by Crae Sosa on 1/21/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol BeaconAdapterDelegate
-(void) didReceiveBeaconArray:(NSMutableDictionary *) beaconArray;
@end

@interface BeaconAdapter : NSObject <CLLocationManagerDelegate>
-(void) controlSetup:(int)s;
-(void) startRangingBeacons;
-(void) stopRangingBeacons;

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableDictionary *beaconArray;
@property (nonatomic,assign) id <BeaconAdapterDelegate> delegate;


@end
