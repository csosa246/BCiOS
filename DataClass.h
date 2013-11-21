//
//  DataClass.h
//  Blue Canary
//
//  Created by Crae Sosa on 11/5/13.
//
//

#import <Foundation/Foundation.h>

@interface DataClass : NSObject{
    NSString *str;
}

@property(nonatomic,retain)NSString *str;
+(DataClass*)getInstance;
@end
