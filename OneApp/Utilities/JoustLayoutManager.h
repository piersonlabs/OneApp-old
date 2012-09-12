//
//  JoustLayoutManager.h
//  FivePlates
//
//  Created by Dane Hesseldahl on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>

enum {
    MODEL_IPHONE_SIMULATOR,
    MODEL_IPOD_TOUCH,
    MODEL_IPHONE,
    MODEL_IPHONE_3G
};

@interface JoustLayoutManager : NSObject

+ (uint) detectDevice;
+ (NSString *) returnDeviceName:(BOOL)ignoreSimulator;

@end
