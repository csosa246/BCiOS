//
//  KeychainAdapter.h
//  Blue Canary
//
//  Created by Crae Sosa on 1/8/14.
//
//

#import <Foundation/Foundation.h>
#import "KeychainItemWrapper.h"

@protocol KeychainDelegate
-(void) userCredentialsDoExist;
-(void) userCredentialsDoNotExist;
@end

@interface KeychainAdapter : NSObject

@property (nonatomic,assign) id <KeychainDelegate> delegate;


@end