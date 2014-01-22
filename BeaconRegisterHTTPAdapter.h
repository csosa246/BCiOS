//
//  BeaconRegisterHTTPAdapter.h
//  Blue Canary
//
//  Created by Crae Sosa on 1/20/14.
//
//

#import <Foundation/Foundation.h>

@interface BeaconRegisterHTTPAdapter : NSObject <NSURLConnectionDelegate>

-(int) controlSetup:(int)s;
@property (strong,nonatomic) NSMutableData *responseData;


@end
