//
//  Beacon.h
//  Bluecast
//
//  Created by Crae Sosa on 1/22/14.
//
//

#import <Foundation/Foundation.h>

@interface Beacon : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *headline;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *linkedinURL;

@end
