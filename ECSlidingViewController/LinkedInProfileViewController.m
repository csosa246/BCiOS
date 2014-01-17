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
@synthesize responseData,alert,linkedinURL;
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    NSString *fullURL = linkedinURL;
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    
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
