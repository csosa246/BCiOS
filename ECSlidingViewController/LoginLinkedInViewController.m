//
//  LoginLinkedInViewController.m
//  Blue Canary
//
//  Created by Crae Sosa on 1/8/14.
//
//

#import "LoginLinkedInViewController.h"

@interface LoginLinkedInViewController ()

@end

@implementation LoginLinkedInViewController
@synthesize webView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    loadedPage = 0;
    webView.delegate = self;
    
    //    DataClass *obj=[DataClass getInstance];
//    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"BlueCanaryLogin" accessGroup:nil];
    
    //    NSString *token = obj.str;
//    NSString *token = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
    
    NSString *urlText = @"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=ul2re6tij2go&state=STATE&redirect_uri=https://bluecanaryalpha.herokuapp.com/linkedin_redirect";
    
    NSURL *url = [NSURL URLWithString:urlText];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"Webview failed");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    loadedPage++;
    if(loadedPage==2){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    NSString *currentURL = webView.request.URL.absoluteString;
    NSLog(currentURL);
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}



@end
