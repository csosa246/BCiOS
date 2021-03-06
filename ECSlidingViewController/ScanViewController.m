//
//  SampleTableViewController.m
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 2/13/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import "ScanViewController.h"
#import "LinkedInProfileViewController.h"

@interface ScanViewController()
@property (nonatomic, strong) NSArray *sampleItems;
@end

@implementation ScanViewController
@synthesize sampleItems;

@synthesize ble,responseData,alertScanningDevices,scanHttp,refresh;
NSMutableArray *peripheralArray;
NSString *uuidToLoad;

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void) viewDidLoad{
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Roboto-Light" size:20.0f], NSFontAttributeName, nil]];
}

- (void)awakeFromNib{
    ble = [[BLE alloc] init];
    [ble controlSetup:1];
    ble.delegate = self;
    
    scanHttp = [[ScanHTTPModel alloc] init];
    [scanHttp controlSetup:1];
    scanHttp.delegate = self;
    
    //Table row refresh stuff-
    refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
}

- (void) bleDidReceivePeripherals:(NSMutableArray *)peripherals{
    if([peripherals count]==0){
        peripheralArray = [[NSMutableArray alloc] init];
        [self alert:NO];
        [self.tableView reloadData];
        return;
    }
    
    NSMutableString *manufacturerDataArray = [NSMutableString string];
    for (int i = 0; i < peripherals.count; i++){
        Peripheral *p = [peripherals objectAtIndex:i];
        NSString *manufacturerData = [p manufacturerData];
        [manufacturerDataArray appendString:manufacturerData];
        
        if(i!=peripherals.count-1){
            [manufacturerDataArray appendString:@","];
        }

//        NSLog(@"Coming from the BLE model:");
//        NSLog(manufacturerData);
    }
    NSLog(manufacturerDataArray);
    
//    NSString *uuidsToLoad = [uuids substringToIndex:[[p manufacturerData] length]-1]
    
//    NSString *uuidsToLoad = @"FC01C226-0EF5-8F59-75C6-1E3CCCFBCA01-ED";
//    NSString *uuidsToLoad = [uuids substringToIndex:[uuids length]-1];
    [scanHttp serverConfirmation:manufacturerDataArray];
}

-(void) bleDidReceivePeripheralAdvertisementData:(NSNumber *)rssi uuid:(NSString *)uuid{}
-(void) bleDidStopScanning{}

-(void)refreshView:(UIRefreshControl *)refresh {
    //Show alert
    [self alert:YES];
    [ble findBLEPeripherals:2];
    [refresh endRefreshing];
}

//Table View code
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [peripheralArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"PhotoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.detailTextLabel.numberOfLines = 2;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    }
    
    NSLog(@"Cell being reloaded");
    //FIND A WAY TO GET THIS INTO THE CONDITIONAL SO THAT IMAGES ARENT DOWNLOADED EVERY FUCKING TIME IT LEAVES THE VIEW
    BLEDevice *current = [peripheralArray objectAtIndex:indexPath.row];
    [cell.imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:current.imageUrl]]]];
    cell.textLabel.text = current.name;
    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Light" size:20.0f];
    cell.detailTextLabel.text = current.headline;
    cell.detailTextLabel.font = [UIFont fontWithName:@"Roboto-Light" size:12.0f];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BLEDevice *current = [peripheralArray objectAtIndex:indexPath.row];
    uuidToLoad = current.uuid;
    [self performSegueWithIdentifier:@"scan2linkedin" sender:self];
}

-(void) scanHTTPconnectionDidFinishLoading:(NSDictionary *)data{
    BLEDevice *bleDevice = [[BLEDevice alloc] init];
    peripheralArray = [[NSMutableArray alloc] init];
    
    for(id key in data){
        
        NSMutableString *firstName = [NSMutableString string];
        [firstName appendString: key];
        [firstName appendString: @".firstName"];
        
        NSMutableString *lastName = [NSMutableString string];
        [lastName appendString: key];
        [lastName appendString: @".lastName"];
        
        NSMutableString *imageUrl = [NSMutableString string];
        [imageUrl appendString: key];
        [imageUrl appendString: @".pictureUrl"];
        
        NSMutableString *headline = [NSMutableString string];
        [headline appendString:key];
        [headline appendString:@".headline"];
        
        NSMutableString *name = [NSMutableString string];
        
        NSString *firstNameData = [data valueForKeyPath:firstName];
        NSString *lastNameData = [data valueForKeyPath:lastName];
        
        [name appendString:firstNameData];
        [name appendString:@" "];
        [name appendString:lastNameData];
        
        NSString *imageUrlData = [data valueForKeyPath:imageUrl];
        NSString *headlineData = [data valueForKeyPath:headline];
        
        bleDevice = [[BLEDevice alloc] init];
        [bleDevice setName:name];
        [bleDevice setHeadline:headlineData];
        [bleDevice setImageUrl:imageUrlData];
        [bleDevice setUuid:key];
        [peripheralArray addObject:bleDevice];
    }
    [self.tableView reloadData];
    [self alert:NO];
}

//Design Features
-(void) setFonts:(UILabel *)label{
    [label setFont:[UIFont fontWithName:@"Roboto-Light" size:label.font.pointSize]];
}

-(void)alert:(BOOL)showAlert{
    if(showAlert){
        alertScanningDevices = [[UIAlertView alloc] initWithTitle:@"Scanning..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        [alertScanningDevices show];
    }else{
        [alertScanningDevices dismissWithClickedButtonIndex:0 animated:YES];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"scan2optiontree"]){
        LinkedInProfileViewController *viewController = (LinkedInProfileViewController *) segue.destinationViewController;
        viewController.uuidToLoad = uuidToLoad;
    }
}

- (IBAction)revealMenu:(id)sender{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

-(void) removeViewController{
    peripheralArray = nil;
    scanHttp = nil;
}

- (IBAction)revealUnderRight:(id)sender{
    [self.slidingViewController anchorTopViewTo:ECLeft];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}
@end