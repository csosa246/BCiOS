//
//  IBeaconAdapter.h
//  Bluecast
//
//  Created by Crae Sosa on 1/21/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol IBeaconAdapterDelegate
-(void) didReceiveBeaconArray:(NSMutableDictionary *) beaconArray;
@end

@interface IBeaconAdapter : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableDictionary *beaconArray;
@property (nonatomic,assign) id <IBeaconAdapterDelegate> delegate;


@end
