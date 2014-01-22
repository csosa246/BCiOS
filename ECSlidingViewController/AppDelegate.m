#import "AppDelegate.h"
#import "LXCBPeripheralServer.h"


/*
 File: ALAppDelegate.m
 Abstract: Main entry point for the application. Displays the main menu and notifies the user when region state transitions occur.
 */

#import "AppDelegate.h"
//#import "ALMenuViewController.h"

@implementation AppDelegate
{
//    ALMenuViewController *_menuViewController;
    UINavigationController *_rootViewController;
    CLLocationManager *_locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    // A user can transition in or out of a region while the application is not running.
    // When this happens CoreLocation will launch the application momentarily, call this delegate method
    // and we will let the user know via a local notification.
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    if(state == CLRegionStateInside)
    {
        notification.alertBody = @"You're inside the region";
    }
    else if(state == CLRegionStateOutside)
    {
        notification.alertBody = @"You're outside the region";
    }
    else
    {
        return;
    }
    
    // If the application is in the foreground, it will get a callback to application:didReceiveLocalNotification:.
    // If its not, iOS will display the notification to the user.
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // This location manager will be used to notify the user of region state transitions.
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Display the main menu.
//    _menuViewController = [[ALMenuViewController alloc] initWithStyle:UITableViewStylePlain];
//    _rootViewController = [[UINavigationController alloc] initWithRootViewController:_menuViewController];
    
//    self.window.rootViewController = _rootViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    // If the application is in the foreground, we will notify the user of the region's state via an alert.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:notification.alertBody message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end


//@interface AppDelegate () <LXCBPeripheralServerDelegate,BluetoothActivationDelegate>
//
//@property (nonatomic, strong) LXCBPeripheralServer *peripheral;
//
//@end
//
//@implementation AppDelegate
//
//- (void)attachUserInterface {
//    
//}
//
//-(void) beginAdvertising{
//    self.peripheral = [[LXCBPeripheralServer alloc] initWithDelegate:self];
//    self.peripheral.serviceName = @"Crae Sosa";
//    self.peripheral.serviceUUID = [CBUUID UUIDWithString:@"7e57"];
//    self.peripheral.characteristicUUID = [CBUUID UUIDWithString:@"b71e"];
//    [self.peripheral startAdvertising];
//}
//
//-(void) resumeAdvertising{
//    [self.peripheral startAdvertising];
//}
//
//-(void) pauseAdvertising{
//    [self.peripheral stopAdvertising];
//}
//
//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    // If the application is in the background state, then we have been
//    // woken up because of a bluetooth event. Otherwise, we can initialize the
//    // UI.
//    NSLog(@"didFinishedLaunching: %@", launchOptions);
//    if (application.applicationState != UIApplicationStateBackground) {
//        [self attachUserInterface];
//    }
//    
//    return YES;
//}
//
//- (void)applicationWillResignActive:(UIApplication *)application {
//}
//
//- (void)applicationDidEnterBackground:(UIApplication *)application {
//    [self.peripheral applicationDidEnterBackground];
//}
//
//- (void)applicationWillEnterForeground:(UIApplication *)application {
//    if (!self.window) {
//        [self attachUserInterface];
//    }
//    [self.peripheral applicationWillEnterForeground];
//}
//
//- (void)applicationDidBecomeActive:(UIApplication *)application {
//}
//
//#pragma mark - LXCBPeripheralServerDelegate
//
//- (void)peripheralServer:(LXCBPeripheralServer *)peripheral centralDidSubscribe:(CBCentral *)central {
//    [self.peripheral sendToSubscribers:[@"Hello" dataUsingEncoding:NSUTF8StringEncoding]];
//}
//
//- (void)peripheralServer:(LXCBPeripheralServer *)peripheral centralDidUnsubscribe:(CBCentral *)central {
//    
//}
//
//@end
