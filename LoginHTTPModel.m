//
//  LoginHTTPModel.m
//  Blue Canary
//
//  Created by Crae Sosa on 10/25/13.


#import "LoginHTTPModel.h"

@implementation LoginHTTPModel
@synthesize responseData,delegate,alertScanningDevices,email,password,credentialsDoExist;

-(int) controlSetup:(int) s{
    [self keychainCheck];
    return 0;
}

//-(void) keychainCheck{
//    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"BlueCanaryLogin" accessGroup:nil];
//    NSString *username = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
//    NSString *token = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
//    
//    NSLog(username);
//    NSLog(token);
//    
//    if(username.length!=0){
//        credentialsDoExist = TRUE;
//        [self serverConfirmation:username password:nil token:token];
//    }else{
//        credentialsDoExist = FALSE;
//    }
//}

-(void) serverConfirmation:(NSString*)email password:(NSString*) password token:(NSString*)token{
    [self alert:YES];
    
    self.responseData = [NSMutableData data];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[@"http://bluecanary.herokuapp.com/mobile/login" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    NSMutableDictionary *tmp;
    
    if(credentialsDoExist)
        tmp = [[NSMutableDictionary alloc] initWithObjectsAndKeys: email, @"email", token, @"token", nil];
    else
        tmp = [[NSMutableDictionary alloc] initWithObjectsAndKeys: email, @"email", password, @"password", nil];
    
//    NSLog(@"%@",tmp);
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
    [self alert:NO];
    NSLog(@"Did Fail");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self alert:NO];
    
    NSError *myError = nil;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    //Getting the token
    NSLog(response);
    
    if(!credentialsDoExist){
        for (NSDictionary * key in data) {
            NSString *token = [key objectForKey:@"token"];
//            //Declare the token in the global data class
//            DataClass *obj=[DataClass getInstance];
//            obj.str = token;
            KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"BlueCanaryLinkedinLogin" accessGroup:nil];
            [keychainItem setObject:@"craetester@gmail.com" forKey:(__bridge id)(kSecValueData)];
            [keychainItem setObject:token forKey:(__bridge id)(kSecAttrAccount)];
        }
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