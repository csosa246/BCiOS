//
//  LoginHTTPModel.h
//  Blue Canary
//
//  Created by Crae Sosa on 10/25/13.
//
//


#import <Foundation/Foundation.h>
#import "DataClass.h"
#import "KeychainItemWrapper.h"

@protocol LoginHTTPDelegate
-(void) loginHTTPconnectionDidFinishLoading:(NSDictionary *)data;
@end

@interface LoginHTTPModel : NSObject <NSURLConnectionDelegate>

-(int) controlSetup:(int) s;
-(void) serverConfirmation:(NSString*)email password:(NSString*)password;
-(void) keychainCheck;

@property (strong,nonatomic) UIAlertView *alertScanningDevices;
@property (nonatomic,assign) id <LoginHTTPDelegate> delegate;
@property (strong,nonatomic) NSMutableData *responseData;

@property (weak, nonatomic) NSString* email;
@property (weak, nonatomic) NSString* password;

@end
