//
//  LoginLinkedInViewController.m
//  Blue Canary
//
//  Created by Crae Sosa on 1/8/14.
//

#import "LoginLinkedInViewController.h"
#import "KeychainItemWrapper.h"

@interface LoginLinkedInViewController ()

@end

@implementation LoginLinkedInViewController
@synthesize webView,keychainAdapter;


- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    loadedPage = 0;
    webView.delegate = self;
    //Setting up the keychain
    keychainAdapter = [[KeychainAdapter alloc] init];
    [keychainAdapter controlSetup:1];
    //Setting up the webview
    [self willLoadWebView];
}

-(void) willLoadWebView{
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
        NSString *currentURL = webView.request.URL.absoluteString;
        NSLog(currentURL);
        if([currentURL rangeOfString:@"error=access_denied"].location != NSNotFound){
//            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            NSString *bid = [currentURL substringFromIndex: [currentURL length] - 1];
            [keychainAdapter setKeyChain:bid];
//            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (IBAction)buttonBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
