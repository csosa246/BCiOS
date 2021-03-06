//
//  MenuViewController.m
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController()
@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation MenuViewController
@synthesize menuItems;

- (void)awakeFromNib{
    self.menuItems = [NSArray arrayWithObjects:@"Scan", @"My Canarys", @"Second", @"Third",@"Logout", nil];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;

    //Load design
    [self loadDesign];
}

-(void) loadDesign{
    //Background
    UIImage *backgroundImage = [UIImage imageNamed:@"still2.png"];
    DesignLibaryModel *designLibrary = [[DesignLibaryModel alloc] init];
    UIImage *imageToBeBlurred = [designLibrary blur:backgroundImage];
    UIColor *backgroundColor = [[UIColor alloc] initWithPatternImage:imageToBeBlurred];
    self.view.backgroundColor = backgroundColor;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex{
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *cellIdentifier = @"MenuItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.highlightedTextColor = [UIColor blackColor];
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Light" size:20.0f];
    cell.textLabel.text = [self.menuItems objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [self.menuItems objectAtIndex:indexPath.row];
    if([identifier isEqualToString:@"Logout"]){
        
        KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"BlueCanaryLogin" accessGroup:nil];
        [keychainItem resetKeychainItem];
        
        [self.slidingViewController setNeedsStatusBarAppearanceUpdate];
        ScanViewController * vc = [[ScanViewController alloc]init];
        [vc removeViewController];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self viewToLoad:identifier];
    }
    

}

-(void) viewToLoad:(NSString *)identifier{
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

@end
