//
//  LoginViewController.h
//  ECSlidingViewController
//
//  Created by Crae Sosa on 10/19/13.
//
//

#import <UIKit/UIKit.h>
#import "DesignLibaryModel.h"
#import "LoginHTTPModel.h"

@interface LoginViewController : UIViewController <LoginHTTPDelegate>{
    IBOutlet UILabel *uiLabelTitle;
}
@property (weak, nonatomic) IBOutlet UITextField *loginEmail;
@property (weak, nonatomic) IBOutlet UITextField *loginPassword;

@property (strong, nonatomic) LoginHTTPModel *loginHTTP;
- (IBAction)didPressLogin:(id)sender;

@end
