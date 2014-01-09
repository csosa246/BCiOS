//
//  LoginLinkedInViewController.h
//  Blue Canary
//
//  Created by Crae Sosa on 1/8/14.
//
//

#import <UIKit/UIKit.h>
#import "KeychainAdapter.h"

@interface LoginLinkedInViewController : UIViewController<UIWebViewDelegate>{
    int loadedPage;
}

@property(strong,nonatomic) KeychainAdapter *keychainAdapter;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)buttonBack:(id)sender;

@end
