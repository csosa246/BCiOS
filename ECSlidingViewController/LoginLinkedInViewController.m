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
    webView.delegate = self;
    //Setting up the keychain
    keychainAdapter = [[KeychainAdapter alloc] init];
    [keychainAdapter controlSetup:1];
    //Setting up the webview
    [self willLoadWebView];
}

-(void) willLoadWebView{
    NSString *urlText = @"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=77upwjrghunhka&state=KNO&redirect_uri=https://bluecastalpha.herokuapp.com/mobile/linkedin/login";
    NSURL *url = [NSURL URLWithString:urlText];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"Webview failed");
}

-(void)webViewDidFinishLoad:(UIWebView *)webViewFinal{
    NSString *url = webViewFinal.request.URL.absoluteString;
    NSLog(url);
    if([url isEqualToString:@"https://www.linkedin.com/uas/oauth2/authorizedialog/submit"]){
        NSLog(@"Wrong login information");
        return;
    }else if ([url isEqualToString:@"https://bluecastalpha.herokuapp.com/mobile/linkedin/login?error=access_denied&error_description=the+user+denied+your+request&state=KNO"]){
        NSLog(@"Hit cancel");
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    NSString *html = [webViewFinal stringByEvaluatingJavaScriptFromString:@"document.body.textContent"];
    NSError *error;
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if([json count]!=0){
        NSLog( @"%@", json );
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (IBAction)buttonBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
