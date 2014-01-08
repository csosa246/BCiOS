//  LoginViewController.m
//  ECSlidingViewController
//  Created by Crae Sosa on 10/19/13.
//
#import "LoginViewController.h"
@interface LoginViewController ()
@end

@implementation LoginViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    //Configuring security
//    [self willSetupSecurity];
    //Loading design
    [self willSetupDesign];
    
//    loginHTTP = [[LoginHTTPModel alloc] init];
//    [loginHTTP controlSetup:1];
//    loginHTTP.delegate = self;
}

//- (void) willSetupSecurity{
//    loginPassword.secureTextEntry = TRUE;
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
//    [loginHTTP serverConfirmation:loginEmail.text password:loginPassword.text token:nil];
    [self performSegueWithIdentifier:@"splash2linkedinlogin" sender:nil];
//    NSLog(@"LOGGING IN ");
    
}

//-(void) loginHTTPconnectionDidFinishLoading:(NSDictionary *)data{
//    [self performSegueWithIdentifier:@"login2init" sender:nil];
//}

@end