//
//  KeychainAdapter.h
//  Blue Canary
//
//  Created by Crae Sosa on 1/8/14.
//
//

#import <Foundation/Foundation.h>
#import "KeychainItemWrapper.h"

@protocol KeychainAdapterDelegate
@required
-(void) userCredentialsDoExist;
-(void) userCredentialsDoNotExist;
@end

@interface KeychainAdapter : NSObject

//Methods
-(int) controlSetup:(int) s;
-(void) keychainCheck;

@property (nonatomic,assign) id <KeychainAdapterDelegate> delegate;




@end
