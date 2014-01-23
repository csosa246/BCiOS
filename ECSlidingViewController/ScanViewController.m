//
//  SampleTableViewController.m
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 2/13/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
#import "ScanViewController.h"
#import "ALDefaults.h"

@implementation ScanViewController
@synthesize myBeaconRegion,locationManager,statusLabel,beaconsDictionary,beaconAdapter,refresh,scanHttp,peripheralArray,linkedInURLToLoad;

- (void)viewDidLoad{
    [super viewDidLoad];
    //Setting up Beacon Adapter
    beaconAdapter = [[BeaconAdapter alloc] init];
    [beaconAdapter controlSetup:1];
    beaconAdapter.delegate = self;
    //Scan HTTP Adapter
    scanHttp = [[ScanHTTPAdapter alloc] init];
    [scanHttp controlSetup:1];
    scanHttp.delegate = self;
    //Setting up refresh controls
    refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
}

-(void)refreshView:(UIRefreshControl *)refresh {
    [beaconAdapter startRangingBeacons];
}

-(void)didReceiveBeaconDictionary:(NSMutableDictionary *)beaconArray{
    beaconsDictionary = beaconArray;
    NSMutableString *beaconsToIdentify = [NSMutableString string];
    for(int i = 0; i<beaconsDictionary.count; i ++){
        NSNumber *sectionKey = [[beaconsDictionary allKeys] objectAtIndex:i];
        CLBeacon *beacon = [[beaconsDictionary objectForKey:sectionKey] objectAtIndex:0];
        [beaconsToIdentify appendString:[beacon.major stringValue]];
    }
    NSLog(beaconsToIdentify);
    [scanHttp shouldIdentifyBeaconsThroughServer:@"1" bid:@"9,2"];
    [self.tableView reloadData];
}

-(void) scanHTTPconnectionDidFinishLoading:(NSArray *)data{
    BeaconModel *beaconModel = [[BeaconModel alloc] init];
    peripheralArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [data count]; i++){
        NSDictionary *dict = [data objectAtIndex:i];
        for(id key in dict){
            NSMutableString *firstNameIndex = [NSMutableString stringWithFormat:@"%@%@", key, @".firstName"];
            NSMutableString *lastNameIndex = [NSMutableString stringWithFormat:@"%@%@", key ,@".lastName"];
            NSMutableString *headlineIndex = [NSMutableString stringWithFormat:@"%@%@", key, @".headline"];
            NSMutableString *pictureURLIndex = [NSMutableString stringWithFormat:@"%@%@", key, @".pictureURL"];
            NSMutableString *linkedinURLIndex = [NSMutableString stringWithFormat:@"%@%@", key, @".linkedinURL"];
            
            NSMutableString *firstLastName = [NSMutableString stringWithFormat:@"%@%@%@", [dict valueForKeyPath:firstNameIndex],@" ", [dict valueForKeyPath: lastNameIndex]];
            NSString * headline = [dict valueForKeyPath:headlineIndex];
            NSString * pictureURL = [dict valueForKeyPath:pictureURLIndex];
            NSString * linkedinURL = [dict valueForKeyPath:linkedinURLIndex];
            
            beaconModel = [[BeaconModel alloc] init];
            [beaconModel setName:firstLastName];
            [beaconModel setHeadline:headline];
            [beaconModel setImageURL:pictureURL];
            [beaconModel setLinkedinURL:linkedinURL];
            [beaconModel setUuid:key];
            [peripheralArray addObject:beaconModel];
        }
    }
    
    [self.tableView reloadData];
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
    BeaconModel *current = [peripheralArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:current.imageURL]]];
    cell.textLabel.text = [current name];
    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Light" size:20.0f];
    cell.detailTextLabel.text = [current headline];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Roboto-Light" size:12.0f];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BeaconModel *current = [peripheralArray objectAtIndex:indexPath.row];
    linkedInURLToLoad = current.linkedinURL;
    [self performSegueWithIdentifier:@"scan2linkedin" sender:self];
}

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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"scan2linkedin"]){
        LinkedInProfileViewController *viewController = (LinkedInProfileViewController *) segue.destinationViewController;
        viewController.linkedinURL = linkedInURLToLoad;
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