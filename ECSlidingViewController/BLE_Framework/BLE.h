
#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
    #import <CoreBluetooth/CoreBluetooth.h>
#else
    #import <IOBluetooth/IOBluetooth.h>
#endif

#import "Peripheral.h"


@protocol BLEDelegate
-(void) bleDidConnect;
-(void) bleDidDisconnect;
-(void) bleDidUpdateRSSI:(NSNumber *) rssi;
-(void) bleDidReceiveData:(unsigned char *) data length:(int) length;
-(void) bleDidReceivePeripherals:(NSMutableArray *)peripherals;
-(void) bleDidReceivePeripheralAdvertisementData:(NSNumber *)rssi uuid:(NSString *)uuid;
-(void) bleDidStopScanning;

@end

@interface BLE : NSObject <CBCentralManagerDelegate, CBPeripheralManagerDelegate,CBPeripheralDelegate> {
}


@property (nonatomic,assign) id <BLEDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *peripherals;
@property (strong, nonatomic) CBCentralManager *CM;
@property (strong, nonatomic) CBPeripheral *activePeripheral;

-(int) controlSetup:(int) s;
-(int) findBLEPeripherals:(int) timeout;

-(UInt16) swap:(UInt16) s;
-(const char *) centralManagerStateToString:(int)state;
-(void) scanTimer:(NSTimer *)timer;
-(void) printKnownPeripherals;
-(void) printPeripheralInfo:(CBPeripheral*)peripheral;
-(int) UUIDSAreEqual:(CFUUIDRef)u1 u2:(CFUUIDRef)u2;

@end