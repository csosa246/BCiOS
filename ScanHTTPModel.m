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

-(void) serverConfirmation:(NSString*)pid bid:(NSString*) bid{
//    [self alert:YES];
    self.responseData = [NSMutableData data];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[@"https://bluecanaryalpha.herokuapp.com/mobile" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithObjectsAndKeys: pid, @"id", bid, @"bid", nil];
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
    //[self alert:NO];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *myError = nil;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
//    NSString *parsed = [response stringByReplacingOccurrencesOfString:@"\\" withString:@""];
//    NSLog(parsed);
//    [[self delegate] scanHTTPconnectionDidFinishLoading:data];
}

@end
