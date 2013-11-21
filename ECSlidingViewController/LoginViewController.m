//
//  LoginViewController.m
//  ECSlidingViewController
//
//  Created by Crae Sosa on 10/19/13.
//
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize loginHTTP;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //Loading design
    [self loadDesign];
    
    loginHTTP = [[LoginHTTPModel alloc] init];
    [loginHTTP controlSetup:1];
    loginHTTP.delegate = self;
}

-(void)loadDesign{
    //[self setFonts:uiLabelTitle];
    UIImage *image = [UIImage imageNamed:@"still2.png"];
    DesignLibaryModel *im = [[DesignLibaryModel alloc] init];
    UIImage *imageToBeBlurred = [im blur:image];
    UIColor *background = [[UIColor alloc] initWithPatternImage:imageToBeBlurred];
    self.view.backgroundColor = background;
    
}

//Set fonts
-(void) setFonts:(UILabel *)label{
    [label setFont:[UIFont fontWithName:@"Roboto-Light" size:label.font.pointSize]];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didPressLogin:(id)sender {
    [loginHTTP serverConfirmation];
}

-(void) loginHTTPconnectionDidFinishLoading:(NSDictionary *)data{
    
    
    [self performSegueWithIdentifier:@"login2init" sender:nil];
}

@end
