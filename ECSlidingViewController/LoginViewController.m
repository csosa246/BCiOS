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
    [keychainAdapter controlSetup:1];
    keychainAdapter.delegate = self;
}

-(void) viewDidAppear:(BOOL)animated{
    [keychainAdapter keychainCheck];
}

-(void) willSetupDesign{
    UIImage *backgroundImage = [UIImage imageNamed:@"still2.png"];
    DesignLibaryAdapter *designLibrary = [[DesignLibaryAdapter alloc] init];
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
    NSLog(@"CREDENTIALS DO EXIST YALL");
    [self performSegueWithIdentifier:@"login2initial" sender:nil];
}

-(void)userCredentialsDoNotExist{
    NSLog(@"CREDENTIALS DONT EXIST YALL");
}

@end