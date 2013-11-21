//
//  LoginHTTPModel.m
//  Blue Canary
//
//  Created by Crae Sosa on 10/25/13.

#import "LoginHTTPModel.h"

@implementation LoginHTTPModel
@synthesize responseData,delegate,alertScanningDevices;

-(int) controlSetup:(int) s{
    
}

-(void) serverConfirmation{
    [self alert:YES];
    self.responseData = [NSMutableData data];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[@"http://bluecanary.herokuapp.com/mobile/login" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    NSString *email = @"craetester@gmail.com";
    NSString *password = @"craetester";
    
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         email, @"email",
                         password, @"password",
                         nil];
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    [request setHTTPBody:postdata];
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    [self alert:NO];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self alert:NO];
    NSError *myError = nil;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    for (NSDictionary * key in data) {
        NSString *token = [key objectForKey:@"token"];
        //Declare the token in the global data class
        DataClass *obj=[DataClass getInstance];
        obj.str = token;
    }
    [[self delegate] loginHTTPconnectionDidFinishLoading:data];
}

-(void)alert:(BOOL)showAlert{
    if(showAlert){
        alertScanningDevices = [[UIAlertView alloc] initWithTitle:@"Logging in..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        [alertScanningDevices show];
    }else{
        [alertScanningDevices dismissWithClickedButtonIndex:0 animated:YES];
    }
}

@end
