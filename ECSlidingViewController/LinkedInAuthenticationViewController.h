//
//  LinkedInAuthenticationViewController.h
//  ECSlidingViewController
//
//  Created by Crae Sosa on 10/20/13.
//
//

#import <UIKit/UIKit.h>
#import "DataClass.h"
#import "KeychainItemWrapper.h"

@interface LinkedInAuthenticationViewController : UIViewController<UIWebViewDelegate>{
    int loadedPage;
}
- (IBAction)goBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
