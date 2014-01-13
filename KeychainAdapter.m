//
//  KeychainAdapter.m
//  Blue Canary
//
//  Created by Crae Sosa on 1/8/14.
//
//

#import "KeychainAdapter.h"

@implementation KeychainAdapter
@synthesize delegate;

-(int) controlSetup:(int) s{
    return 0;
}

-(void) keychainCheck{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"BlueCanaryLinkedInLogin" accessGroup:nil];
    NSString *username = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
    NSString *bid = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
    NSLog(username);
    NSLog(bid);
    if(username.length!=0 & bid.length!=0){
        [[self delegate] userCredentialsDoExist];
    }else{
        [[self delegate] userCredentialsDoNotExist];
    }
}

-(void) setKeyChain:(NSString*) bid{
    NSLog(@"is this even being called");
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"BlueCanaryLinkedInLogin" accessGroup:nil];
    [keychainItem setObject:@"user" forKey:(__bridge id)(kSecValueData)];
    [keychainItem setObject:bid forKey:(__bridge id)(kSecAttrAccount)];
}

@end
