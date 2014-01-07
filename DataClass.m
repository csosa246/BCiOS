//
//  DataClass.m
//  Blue Canary
//
//  Created by Crae Sosa on 11/5/13.
//
//

#import "DataClass.h"

//DataClass.m
@implementation DataClass
@synthesize str;
static DataClass *instance =nil;
+(DataClass *)getInstance{
    @synchronized(self){
        if(instance==nil){
            instance= [DataClass new];
        }
    }
    return instance;
}
@end