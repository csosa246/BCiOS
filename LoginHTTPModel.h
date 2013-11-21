//
//  LoginHTTPModel.h
//  Blue Canary
//
//  Created by Crae Sosa on 10/25/13.
//
//


#import <Foundation/Foundation.h>
#import "DataClass.h"

@protocol LoginHTTPDelegate
-(void) loginHTTPconnectionDidFinishLoading:(NSDictionary *)data;
@end

@interface LoginHTTPModel : NSObject <NSURLConnectionDelegate>

-(int) controlSetup:(int) s;
-(void) serverConfirmation;
@property (strong,nonatomic) UIAlertView *alertScanningDevices;
@property (nonatomic,assign) id <LoginHTTPDelegate> delegate;
@property (strong,nonatomic) NSMutableData *responseData;

@end
