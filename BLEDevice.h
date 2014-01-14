//
//  BLEDevice.h
//  BlueCanary
//
//  Created by Crae Sosa on 8/16/13.
//  Copyright (c) 2013 com.appiari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLEDevice : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *headline;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *linkedinURL;

@end
