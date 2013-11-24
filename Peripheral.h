//
//  Peripheral.h
//  Blue Canary
//
//  Created by Crae Sosa on 10/24/13.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface Peripheral : NSObject

@property(strong,nonatomic) NSNumber* rssi;
@property(strong,nonatomic) NSString* uuid;
@property(strong,nonatomic) NSString* manufacturerData; 
@property(strong,nonatomic) CBPeripheral *peripheral; 

@end
