//Copyright (c) 2012 RedBearLab
#import "BLE.h"
#import "BLEDefines.h"

@implementation BLE

@synthesize delegate;
@synthesize CM;
@synthesize peripherals;
@synthesize activePeripheral;
static UInt16 libver = 0;
static unsigned char vendor_name[20] = {0};
static bool isConnected = false;
static int rssi = 0;

-(int) readRSSI{
    return rssi;
}

-(UInt16) readLibVer{
    return libver;
}

-(UInt16) readFrameworkVersion{
    return BLE_FRAMEWORK_VERSION;
}

-(NSString *) readVendorName{
    return [NSString stringWithFormat:@"%s", vendor_name];
}

-(UInt16) swap:(UInt16)s{
    UInt16 temp = s << 8;
    temp |= (s >> 8);
    return temp;
}

- (int) controlSetup: (int) s{
    self.CM = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
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
    return 0; // Started scanning OK !
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;{
    done = false;
    [[self delegate] bleDidDisconnect];
    isConnected = false;
}

- (void) connectPeripheral:(CBPeripheral *)peripheral {
    //printf("Connecting to peripheral with UUID : %s\r\n",[self UUIDToString:peripheral.UUID]);
    self.activePeripheral = peripheral;
    self.activePeripheral.delegate = self;
    [self.CM connectPeripheral:self.activePeripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
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
    //int i;
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

-(const char *) CBUUIDToString:(CBUUID *) UUID{
    return [[UUID.data description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
}

-(const char *) UUIDToString:(CFUUIDRef)UUID{
    if (!UUID)
        return "NULL";
    
    CFStringRef s = CFUUIDCreateString(NULL, UUID);
    return CFStringGetCStringPtr(s, 0);
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
    CFStringRef s = CFUUIDCreateString(NULL, peripheral.UUID);
    NSString *uuidFormatted = (__bridge NSString *)s;
    
    [[self delegate] bleDidReceivePeripheralAdvertisementData:RSSI uuid:uuidFormatted] ;
    
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

static bool done = false;
@end