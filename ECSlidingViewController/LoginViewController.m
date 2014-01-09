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
    //Loading design
    [self willSetupDesign];
}

-(void)viewDidAppear:(BOOL)animated{
//    [self keychainCheck];
    
}

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
    
}

-(void)userCredentialsDoNotExist{
    
}

//-(void) keychainCheck{
//    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"BlueCanaryLinkedInLogin" accessGroup:nil];
//    NSString *username = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
//    NSString *bid = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
//
//    NSLog(username);
//    NSLog(bid);
//
//    if(username.length!=0){
//        credentialsDoExist = TRUE;
//        NSLog(@"Credentials exist");
////        [self performSegueWithIdentifier:@"login2initial" sender:nil];
//        [self performSegueWithIdentifier:@"login2initial" sender:nil];
//
//    }else{
//        credentialsDoExist = FALSE;
//        NSLog(@"credentials do not exist");
//        //go to the linkedin login page
//        
//    }
//}


@end