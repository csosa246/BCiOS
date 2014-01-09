//  LoginViewController.m
//  ECSlidingViewController
//  Created by Crae Sosa on 10/19/13.
//
#import "LoginViewController.h"
@interface LoginViewController ()
@end

@implementation LoginViewController
@synthesize keychainAdapter;

- (void)viewDidLoad{
    [super viewDidLoad];
    //Loading design
    [self willSetupDesign];
    
    keychainAdapter = [[KeychainAdapter alloc] init];
    [keychainAdapter keychainCheck];
//    [keychainAdapter controlSetup:1];
    keychainAdapter.delegate = self;
}

//-(void)viewDidAppear:(BOOL)animated{
//    keychainAdapter = [[KeychainAdapter alloc] init];
//    //    [keychainAdapter controlSetup:1];
//    [keychainAdapter keychainCheck];
//    keychainAdapter.delegate = self;
//}

-(void) willSetupDesign{
    UIImage *backgroundImage = [UIImage imageNamed:@"still2.png"];
    DesignLibaryModel *designLibrary = [[DesignLibaryModel alloc] init];
    UIColor *backgroundColor = [[UIColor alloc] initWithPatternImage:[designLibrary blur:backgroundImage]];
    self.view.backgroundColor = backgroundColor;
    //Fonts
    [designLibrary setFonts:uiLabelTitle];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (IBAction)didPressLogin:(id)sender {
    [self performSegueWithIdentifier:@"splash2linkedinlogin" sender:nil];
}

-(void)userCredentialsDoExist{
    NSLog(@"CREDENTIALS EXIST YALL");
}

-(void)userCredentialsDoNotExist{
    NSLog(@"CREDENTIALS DONT EXIST YALL");
}

@end