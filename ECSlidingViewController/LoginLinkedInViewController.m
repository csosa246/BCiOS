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
@synthesize webView;

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    loadedPage = 0;
    webView.delegate = self;
    
//    //    DataClass *obj=[DataClass getInstance];
//    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"BlueCanaryLinkedInLogin" accessGroup:nil];
//    
//    
//    NSString *username
//    NSString *bid = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
    
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
//        NSLog(currentURL);
        
        if([currentURL rangeOfString:@"error=access_denied"].location != NSNotFound){
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            NSString *bid = [currentURL substringFromIndex: [currentURL length] - 1];
            KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"BlueCanaryLinkedInLogin" accessGroup:nil];
            [keychainItem setObject:@"user" forKey:(__bridge id)(kSecValueData)];
            [keychainItem setObject:bid forKey:(__bridge id)(kSecAttrAccount)];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}



@end
