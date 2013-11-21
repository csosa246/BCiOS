//
//  SignUpViewController.m
//  ECSlidingViewController
//
//  Created by Crae Sosa on 10/22/13.
//
//

#import "SignUpViewController.h"


@interface SignUpViewController ()

@end

@implementation SignUpViewController

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
    
    [self loadDesign];
}

-(void) loadDesign{
    //Background
    //Background
    UIImage *image = [UIImage imageNamed:@"still2.png"];
    DesignLibaryModel *im = [[DesignLibaryModel alloc] init];
    UIImage *imageToBeBlurred = [im blur:image];
    UIColor *background = [[UIColor alloc] initWithPatternImage:imageToBeBlurred];
    self.view.backgroundColor = background;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)didClickBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didClickSignUp:(id)sender {
    
    [self performSegueWithIdentifier:@"signup2linkedinlinkaccount" sender:self];
}
@end
