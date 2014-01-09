//
//  LoginLinkedInViewController.h
//  Blue Canary
//
//  Created by Crae Sosa on 1/8/14.
//
//

#import <UIKit/UIKit.h>

@interface LoginLinkedInViewController : UIViewController<UIWebViewDelegate>{
    int loadedPage;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)buttonBack:(id)sender;

@end
