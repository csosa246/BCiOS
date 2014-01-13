//
//  ScanHTTPModel.m
//  Blue Canary
//
//  Created by Crae Sosa on 10/25/13.

#import "ScanHTTPModel.h"

@implementation ScanHTTPModel
@synthesize responseData,delegate;

-(int) controlSetup:(int) s{
    return 0;
}

-(void) serverConfirmation:(NSString *)uuidsToLoad{
    self.responseData = [NSMutableData data];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[@"https://bluecanaryconnect.appspot.com/apphandle" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"ed" forHTTPHeaderField:@"NAME"];
    [request setValue:@"ed" forHTTPHeaderField:@"PASSWORD"];
    [request setValue:@"UUID" forHTTPHeaderField:@"COMMAND"];
    [request setValue:uuidsToLoad forHTTPHeaderField:@"UUID"];
    
    NSLog(uuidsToLoad);
    //For testing
    //[request setValue:@"7B72663A-7000-A511-F23C-9E2E5A2C7528,FC01C226-0EF5-8F59-75C6-1E3CCCFBCA01,12345" forHTTPHeaderField:@"UUID"];
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
    //[self alert:NO];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *myError = nil;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    NSLog(response);
    [[self delegate] scanHTTPconnectionDidFinishLoading:data];
}

@end
