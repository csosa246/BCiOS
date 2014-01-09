//
//  LoginViewController.h
//  ECSlidingViewController
//
//  Created by Crae Sosa on 10/19/13.
//
//

#import <UIKit/UIKit.h>
#import "DesignLibaryModel.h"
#import "KeychainAdapter.h"

@interface LoginViewController : UIViewController<KeychainAdapterDelegate>{
    IBOutlet UILabel *uiLabelTitle;
}

@property (strong, nonatomic) KeychainAdapter *keychainAdapter;
- (IBAction)didPressLogin:(id)sender;

@end
