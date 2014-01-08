//
//  LinkedInAuthenticationViewController.m
//  ECSlidingViewController
//
//  Created by Crae Sosa on 10/20/13.
//
//

#import "LinkedInAuthenticationViewController.h"

@interface LinkedInAuthenticationViewController ()

@end

@implementation LinkedInAuthenticationViewController
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
    
    NSLog(@"LOADING VIEW");
    loadedPage = 0;

    webView.delegate = self;
    
//    DataClass *obj=[DataClass getInstance];
    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"BlueCanaryLogin" accessGroup:nil];
    
    NSString *baseUrl = @"http://bluecanary.herokuapp.com/linkedin/authorize?email=";
    NSString *email = @"craetester@gmail.com";
    NSString *remember = @"&remeber=";
    
    NSString *token = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
    
    NSArray *myStrings = [[NSArray alloc] initWithObjects:baseUrl, email, remember, token, nil];
    NSString *fullURL = [myStrings componentsJoinedByString:@""];
    
    NSLog(fullURL);
    
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    
    //Set the values
    NSString* firstValue = @"crae";
    NSString* secondValue = @"crae";
    // write javascript code in a string
    NSString* javaScriptString = @"";
    
    
    // insert string values into javascript
    javaScriptString = [NSString stringWithFormat: javaScriptString, firstValue, secondValue];
    
    // run javascript in webview:
    [webView stringByEvaluatingJavaScriptFromString: javaScriptString];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"webView DidFinishLoad");
    loadedPage++;
    
    //[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('username').value='peter';"];
    
    if(loadedPage==2){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    NSString *currentURL = webView.request.URL.absoluteString;
    NSLog(currentURL);
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
