//Copyright (c) 2012 RedBearLab
#import "BLE.h"
#import "BLEDefines.h"

@implementation BLE

@synthesize delegate;
@synthesize CM;
@synthesize peripherals;
@synthesize activePeripheral;
@synthesize peripheralDeviceArray;

-(UInt16) swap:(UInt16)s{
    UInt16 temp = s << 8;
    temp |= (s >> 8);
    return temp;
}

- (int) controlSetup: (int) s{
    self.CM = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    peripheralDeviceArray = [[NSMutableArray alloc] init];
    return 0;
}

- (int) findBLEPeripherals:(int) timeout{
    //Remove all objects within the array 
    [peripherals removeAllObjects];
    if (self.CM.state != CBCentralManagerStatePoweredOn) {
        printf("CoreBluetooth not correctly initialized !\r\n");
        printf("State = %d (%s)\r\n", self.CM.state,[self centralManagerStateToString:self.CM.state]);
        return -1;
    }
    
    [NSTimer scheduledTimerWithTimeInterval:(float)timeout target:self selector:@selector(scanTimer:) userInfo:nil repeats:NO];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    [self.CM scanForPeripheralsWithServices:nil options:options]; // Start scanning
    NSLog(@"scanForPeripheralsWithServices");
    return 0;
}

- (const char *) centralManagerStateToString: (int)state{
    switch(state){
        case CBCentralManagerStateUnknown:
            return "State unknown (CBCentralManagerStateUnknown)";
        case CBCentralManagerStateResetting:
            return "State resetting (CBCentralManagerStateUnknown)";
        case CBCentralManagerStateUnsupported:
            return "State BLE unsupported (CBCentralManagerStateResetting)";
        case CBCentralManagerStateUnauthorized:
            return "State unauthorized (CBCentralManagerStateUnauthorized)";
        case CBCentralManagerStatePoweredOff:
            return "State BLE powered off (CBCentralManagerStatePoweredOff)";
        case CBCentralManagerStatePoweredOn:
            return "State powered up and ready (CBCentralManagerStatePoweredOn)";
        default:
            return "State unknown";
    }
    return "Unknown state";
}

- (void) scanTimer:(NSTimer *)timer{
    [self.CM stopScan];
    printf("Stopped Scanning\r\n");
    printf("Known peripherals : %d\r\n",[self.peripherals count]);
    [self printKnownPeripherals];
    [delegate bleDidStopScanning];
}

- (void) printKnownPeripherals{
    printf("List of currently known peripherals : \r\n");
    [[self delegate] bleDidReceivePeripherals:peripherals];
}

- (int) UUIDSAreEqual:(CFUUIDRef)u1 u2:(CFUUIDRef)u2{
    CFUUIDBytes b1 = CFUUIDGetUUIDBytes(u1);
    CFUUIDBytes b2 = CFUUIDGetUUIDBytes(u2);
    
    if (memcmp(&b1, &b2, 16) == 0) {
        return 1;
    }else
        return 0;
}

#if TARGET_OS_IPHONE
//-- no need for iOS
#else
- (BOOL) isLECapableHardware{
    NSString * state = nil;
    
    switch ([CM state]){
        case CBCentralManagerStateUnsupported:
            state = @"The platform/hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff:
            state = @"Bluetooth is currently powered off.";
            break;
        case CBCentralManagerStatePoweredOn:
            return TRUE;
        case CBCentralManagerStateUnknown:
        default:
            return FALSE;
    }
    
    NSLog(@"Central manager state: %@", state);
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:state];
    [alert addButtonWithTitle:@"OK"];
    [alert setIcon:[[NSImage alloc] initWithContentsOfFile:@"AppIcon"]];
    [alert beginSheetModalForWindow:nil modalDelegate:self didEndSelector:nil contextInfo:nil];
    return FALSE;
}
#endif

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
#if TARGET_OS_IPHONE
    printf("Status of CoreBluetooth central manager changed %d (%s)\r\n",central.state,[self centralManagerStateToString:central.state]);
#else
    [self isLECapableHardware];
#endif
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    NSString *manufacturerData = [NSString stringWithFormat:@"%@",[advertisementData valueForKey: @"kCBAdvDataManufacturerData"]];
    manufacturerData = [manufacturerData stringByReplacingOccurrencesOfString:@">" withString:@""];
    manufacturerData = [manufacturerData stringByReplacingOccurrencesOfString:@"<" withString:@""];
    NSLog(manufacturerData);
    NSString *rssi = [NSString stringWithFormat:@"%@",RSSI];
    //Did discover something, and so send this data to a method along with RSSI and UUID
    [self bleDidReceivePeripheralAdvertisementData:RSSI manufactureData:manufacturerData] ;
    
    Peripheral *peripheralModel = [[Peripheral alloc] init];
    [peripheralModel setManufacturerData:manufacturerData];
    [peripheralModel setPeripheral:peripheral];
    
    if (!self.peripherals)
        self.peripherals = [[NSMutableArray alloc] initWithObjects:peripheralModel,nil];
    else{
        for(int i = 0; i < self.peripherals.count; i++){
            Peripheral *p = [self.peripherals objectAtIndex:i];
            if ((p.peripheral.UUID == NULL) || (peripheral.UUID == NULL))
                continue;
            if ([self UUIDSAreEqual:p.peripheral.UUID u2:peripheral.UUID]){
                [self.peripherals replaceObjectAtIndex:i withObject:peripheralModel];
                printf("Duplicate UUID found updating ...\n");
                return;
            }
        }
        
        [self.peripherals addObject:peripheralModel];
        printf("New UUID, adding\r\n");
    }
    printf("didDiscoverPeripheral\r\n");
}

//i less than 5
-(void) bleDidReceivePeripheralAdvertisementData:(NSNumber *)rssi manufactureData:(NSString *)manufactureData {
    NSString *rssiText = [NSString stringWithFormat:@"%@",rssi];
    Peripheral *peripheralDevice = [[Peripheral alloc] init];
    [peripheralDevice setManufacturerData:manufactureData];
    [peripheralDevice setRssi:rssi];
    [peripheralDeviceArray addObject:peripheralDevice];
}
//i greater than 5
-(void) didFinishScanAndCompiling{
    //Do some comparitive data analysis
    NSNumber *greatestRssi = [[NSNumber alloc] initWithDouble:-9999];
    int indexOfGreatestRssi = 0;
    for(int j = 0; j<peripheralDeviceArray.count; j ++){
        Peripheral *peripheral = [peripheralDeviceArray objectAtIndex:j];
        NSNumber *rssi = [peripheral rssi];
        NSLog(@"%@",rssi);
        if ([rssi intValue] > [greatestRssi intValue] & [rssi intValue] < 0){
            greatestRssi = rssi;
            indexOfGreatestRssi = j;
        }
    }
    NSLog(@"GREATEST RSSI");
    NSLog(@"%@",greatestRssi);

    if(peripheralDeviceArray.count!=0 && ([greatestRssi intValue] > -60) && ([greatestRssi intValue] <0)){
        NSLog(@"ARE WE EVERY GOING IN HERE");
        Peripheral *peripheralToConnect = [peripheralDeviceArray objectAtIndex:indexOfGreatestRssi];
        NSString *closestPeripheral = [peripheralToConnect manufacturerData];
        [[self delegate] bleDidFindPeripheralToRegister:closestPeripheral];
    }else{
        NSString *message = @"No devices found.";
        [[self delegate] bleDidNotFindPeripheralToRegister:message];

    }
    [peripheralDeviceArray removeAllObjects];
}
@end