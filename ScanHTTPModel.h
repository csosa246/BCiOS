//
//  ScanHTTPModel.h
//  Blue Canary
//
//  Created by Crae Sosa on 10/25/13.
//
//


#import <Foundation/Foundation.h>

@protocol ScanHTTPDelegate
-(void) scanHTTPconnectionDidFinishLoading:(NSDictionary *)data;
@end

@interface ScanHTTPModel : NSObject <NSURLConnectionDelegate>

-(int) controlSetup:(int) s;
-(void) serverConfirmation:(NSString*)pid bid:(NSString*) bid;
@property (nonatomic,assign) id <ScanHTTPDelegate> delegate;
@property (strong,nonatomic) NSMutableData *responseData;

@end
