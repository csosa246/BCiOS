//
//  LinkedInProfileViewController.m
//  BlueCanary
//
//  Created by Crae Sosa on 8/26/13.
//  Copyright (c) 2013 com.appiari. All rights reserved.

#import "LinkedInProfileViewController.h"

@interface LinkedInProfileViewController ()
@end

@implementation LinkedInProfileViewController
@synthesize responseData,alert,uuidToLoad;
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    NSString *fullURL = @"http://www.linkedin.com/in/haythamelhawary";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    
    
    //Loading dialog
    alert = [[UIAlertView alloc] initWithTitle:@"Loading..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [alert show];
    
    self.responseData = [NSMutableData data];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[@"https://bluecanaryconnect.appspot.com/apphandle" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"ed" forHTTPHeaderField:@"NAME"];
    [request setValue:@"ed" forHTTPHeaderField:@"PASSWORD"];
    [request setValue:@"LINKEDIN" forHTTPHeaderField:@"COMMAND"];
    [request setValue:uuidToLoad forHTTPHeaderField:@"UUID"];
    //[request setValue:@"A2F01946-7461-BB1B-1C9E-CD2749EC2977" forHTTPHeaderField:@"UUID"];
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//HTTP Request
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"We received a response");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Connection finished loading!");
    
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}
@end
