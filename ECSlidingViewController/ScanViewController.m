//
//  SampleTableViewController.m
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 2/13/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import "ScanViewController.h"
#import "ALDefaults.h"

@implementation ScanViewController
{
    NSMutableDictionary *_beacons;
    CLLocationManager *_locationManager;
    NSMutableArray *_rangedRegions;
}

- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	if(self)
	{
        _beacons = [[NSMutableDictionary alloc] init];
        // This location manager will be used to demonstrate how to range beacons.
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
	}
	
	return self;
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    
    NSLog(@"manager was called");
    // CoreLocation will call this delegate method at 1 Hz with updated range information.
    // Beacons will be categorized and displayed by proximity.
    [_beacons removeAllObjects];
    NSArray *unknownBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityUnknown]];
    if([unknownBeacons count])
        [_beacons setObject:unknownBeacons forKey:[NSNumber numberWithInt:CLProximityUnknown]];
    
    NSArray *immediateBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityImmediate]];
    if([immediateBeacons count])
        [_beacons setObject:immediateBeacons forKey:[NSNumber numberWithInt:CLProximityImmediate]];
    
    NSArray *nearBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityNear]];
    if([nearBeacons count])
        [_beacons setObject:nearBeacons forKey:[NSNumber numberWithInt:CLProximityNear]];
    
    NSArray *farBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityFar]];
    if([farBeacons count])
        [_beacons setObject:farBeacons forKey:[NSNumber numberWithInt:CLProximityFar]];
    
    [self.tableView reloadData];    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    // Start ranging when the view appears.
    [_rangedRegions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CLBeaconRegion *region = obj;
        [_locationManager startRangingBeaconsInRegion:region];
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // Stop ranging when the view goes away.
    [_rangedRegions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CLBeaconRegion *region = obj;
        [_locationManager stopRangingBeaconsInRegion:region];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Populate the regions we will range once.
    _rangedRegions = [NSMutableArray array];
    [[ALDefaults sharedDefaults].supportedProximityUUIDs enumerateObjectsUsingBlock:^(id uuidObj, NSUInteger uuidIdx, BOOL *uuidStop) {
        NSUUID *uuid = (NSUUID *)uuidObj;
        
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:[uuid UUIDString]];
        [_rangedRegions addObject:region];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _beacons.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionValues = [_beacons allValues];
    return [[sectionValues objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    NSArray *sectionKeys = [_beacons allKeys];
    
    // The table view will display beacons by proximity.
    NSNumber *sectionKey = [sectionKeys objectAtIndex:section];
    switch([sectionKey integerValue])
    {
        case CLProximityImmediate:
            title = @"Immediate";
            break;
            
        case CLProximityNear:
            title = @"Near";
            break;
            
        case CLProximityFar:
            title = @"Far";
            break;
            
        default:
            title = @"Unknown";
            break;
    }
    
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    
    // Display the UUID, major, minor and accuracy for each beacon.
    NSNumber *sectionKey = [[_beacons allKeys] objectAtIndex:indexPath.section];
    CLBeacon *beacon = [[_beacons objectForKey:sectionKey] objectAtIndex:indexPath.row];
    cell.textLabel.text = [beacon.proximityUUID UUIDString];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Major: %@, Minor: %@, Acc: %.2fm", beacon.major, beacon.minor, beacon.accuracy];
    return cell;
}

//@end



//- (void)awakeFromNib{
//    ble = [[BLE alloc] init];
//    [ble controlSetup:1];
//    ble.delegate = self;
//
//    scanHttp = [[ScanHTTPAdapter alloc] init];
//    [scanHttp controlSetup:1];
//    scanHttp.delegate = self;
//    
//    //Table row refresh stuff-
//    refresh = [[UIRefreshControl alloc] init];
//    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
//    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
//    self.refreshControl = refresh;
//}
//
//- (void) bleDidReceivePeripherals:(NSMutableArray *)peripherals{
//    if([peripherals count]==0){
//        peripheralArray = [[NSMutableArray alloc] init];
//        [self alert:NO];
//        [self.tableView reloadData];
//        return;
//    }
//    
//    NSMutableString *bidCollection = [NSMutableString string];
//    for (int i = 0; i < peripherals.count; i++){
//        Peripheral *p = [peripherals objectAtIndex:i];
//        NSString *manufacturerData = [p manufacturerData];
//        NSString *bid = [manufacturerData substringWithRange:NSMakeRange(1, 1)];
//        NSLog(@"Coming from the BLE model:");
//        [bidCollection appendString:bid];
//        [bidCollection appendString:@","];
//    }
//    NSLog(bidCollection);
//
////    NSString *uuidsToLoad = @"FC01C226-0EF5-8F59-75C6-1E3CCCFBCA01-ED";
////    NSString *uuidsToLoad = [uuids substringToIndex:[uuids length]-1];
//    NSString *bidsToLoad = [bidCollection substringToIndex:[bidCollection length]-1];
//    NSLog(bidsToLoad);
//
////    [scanHttp serverConfirmation:@"1" bid:@"1,2,3"];
//    [scanHttp serverConfirmation:@"1" bid:bidsToLoad];
//
//}
//
//-(void) bleDidReceivePeripheralAdvertisementData:(NSNumber *)rssi uuid:(NSString *)uuid{}
//-(void) bleDidStopScanning{}
//
//-(void)refreshView:(UIRefreshControl *)refresh {
//    //Show alert
//    [self alert:YES];
//    [ble findBLEPeripherals:2];
//    [refresh endRefreshing];
//}
//
////Table View code
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return [peripheralArray count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *CellIdentifier = @"PhotoCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if(cell==nil){
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//        cell.detailTextLabel.numberOfLines = 2;
//        cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
//    }
//    
//    NSLog(@"Cell being reloaded");
//    //FIND A WAY TO GET THIS INTO THE CONDITIONAL SO THAT IMAGES ARENT DOWNLOADED EVERY FUCKING TIME IT LEAVES THE VIEW
//    BLEDevice *current = [peripheralArray objectAtIndex:indexPath.row];
//    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:current.imageURL]]];
//    cell.textLabel.text = [current name];
//    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Light" size:20.0f];
//    cell.detailTextLabel.text = [current headline];
//    cell.detailTextLabel.font = [UIFont fontWithName:@"Roboto-Light" size:12.0f];
//    cell.detailTextLabel.textColor = [UIColor grayColor];
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 100;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    BLEDevice *current = [peripheralArray objectAtIndex:indexPath.row];
//    linkedinURLToLoad = current.linkedinURL;
//    [self performSegueWithIdentifier:@"scan2linkedin" sender:self];
//}
//
//-(void) scanHTTPconnectionDidFinishLoading:(NSArray *)data{
//    BLEDevice *bleDevice = [[BLEDevice alloc] init];
//    peripheralArray = [[NSMutableArray alloc] init];
//    
//    for (int i = 0; i < [data count]; i++){
//        NSDictionary *dict = [data objectAtIndex:i];
//        for(id key in dict){
//            NSMutableString *firstNameIndex = [NSMutableString stringWithFormat:@"%@%@", key, @".firstName"];
//            NSMutableString *lastNameIndex = [NSMutableString stringWithFormat:@"%@%@", key ,@".lastName"];
//            NSMutableString *headlineIndex = [NSMutableString stringWithFormat:@"%@%@", key, @".headline"];
//            NSMutableString *pictureURLIndex = [NSMutableString stringWithFormat:@"%@%@", key, @".pictureURL"];
//            NSMutableString *linkedinURLIndex = [NSMutableString stringWithFormat:@"%@%@", key, @".linkedinURL"];
//
//            NSMutableString *firstLastName = [NSMutableString stringWithFormat:@"%@%@%@", [dict valueForKeyPath:firstNameIndex],@" ", [dict valueForKeyPath: lastNameIndex]];
//            NSString * headline = [dict valueForKeyPath:headlineIndex];
//            NSString * pictureURL = [dict valueForKeyPath:pictureURLIndex];
//            NSString * linkedinURL = [dict valueForKeyPath:linkedinURLIndex];
//            
//            bleDevice = [[BLEDevice alloc] init];
//            [bleDevice setName:firstLastName];
//            [bleDevice setHeadline:headline];
//            [bleDevice setImageURL:pictureURL];
//            [bleDevice setLinkedinURL:linkedinURL];
//            [bleDevice setUuid:key];
//            [peripheralArray addObject:bleDevice];
//        }
//    }
//    
//    [self.tableView reloadData];
//    [self alert:NO];
//}

//Design Features
-(void) setFonts:(UILabel *)label{
    [label setFont:[UIFont fontWithName:@"Roboto-Light" size:label.font.pointSize]];
}

//-(void)alert:(BOOL)showAlert{
//    if(showAlert){
//        alertScanningDevices = [[UIAlertView alloc] initWithTitle:@"Scanning..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
//        [alertScanningDevices show];
//    }else{
//        [alertScanningDevices dismissWithClickedButtonIndex:0 animated:YES];
//    }
//}
//
//
//- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if([segue.identifier isEqualToString:@"scan2linkedin"]){
//        LinkedInProfileViewController *viewController = (LinkedInProfileViewController *) segue.destinationViewController;
//        viewController.linkedinURL = linkedinURLToLoad;
//    }
//}

- (IBAction)revealMenu:(id)sender{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

-(void) removeViewController{
//    peripheralArray = nil;
//    scanHttp = nil;
}

- (IBAction)revealUnderRight:(id)sender{
    [self.slidingViewController anchorTopViewTo:ECLeft];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}
@end