#import "AppDelegate.h"
#import "LXCBPeripheralServer.h"

@interface AppDelegate () <LXCBPeripheralServerDelegate,BluetoothActivationDelegate>

@property (nonatomic, strong) LXCBPeripheralServer *peripheral;

@end

@implementation AppDelegate

- (void)attachUserInterface {
    
}

-(void) beginAdvertising{
    self.peripheral = [[LXCBPeripheralServer alloc] initWithDelegate:self];
    self.peripheral.serviceName = @"Crae Sosa";
    self.peripheral.serviceUUID = [CBUUID UUIDWithString:@"7e57"];
    
    self.peripheral.characteristicUUID = [CBUUID UUIDWithString:@"b71e"];
    [self.peripheral startAdvertising];
}

-(void) resumeAdvertising{
    [self.peripheral startAdvertising];
}

-(void) pauseAdvertising{
    
    [self.peripheral stopAdvertising];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // If the application is in the background state, then we have been
    // woken up because of a bluetooth event. Otherwise, we can initialize the
    // UI.
    NSLog(@"didFinishedLaunching: %@", launchOptions);
    if (application.applicationState != UIApplicationStateBackground) {
        [self attachUserInterface];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self.peripheral applicationDidEnterBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    if (!self.window) {
        [self attachUserInterface];
    }
    [self.peripheral applicationWillEnterForeground];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

//- (void)applicationWillTerminate:(UIApplication *)application {
//    NSLog(@"Application terminating");
//    // Cry for help.
//    UILocalNotification *notification = [[UILocalNotification alloc] init];
//    notification.alertBody = @"I'm dying!";
//    notification.alertAction = @"Rescue";
//    notification.fireDate = [NSDate date];
//    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//}

#pragma mark - LXCBPeripheralServerDelegate

- (void)peripheralServer:(LXCBPeripheralServer *)peripheral centralDidSubscribe:(CBCentral *)central {
    [self.peripheral sendToSubscribers:[@"Hello" dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)peripheralServer:(LXCBPeripheralServer *)peripheral centralDidUnsubscribe:(CBCentral *)central {
    
}

@end
