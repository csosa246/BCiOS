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

//-(int) controlSetup:(int) s{
//    [self keychainCheck];
//    return 0;
//}

-(void) keychainCheck{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"BlueCanaryLinkedInLogin" accessGroup:nil];
    NSString *username = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
    NSString *bid = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
    if(username.length!=0){
        [[self delegate] userCredentialsDoExist];
    }else{
        [[self delegate] userCredentialsDoNotExist];
    }
}

@end
