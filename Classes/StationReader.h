//
//  StationReader.h
//  HalvinBensa
//
//  Created by Lauri Larjo on 11/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Debug.h"
#import "StationItem.h"
#import "PriceItem.h"
#import "JSON.h"


@interface StationReader : NSObject {

}

- (NSArray *)getStationItems:(NSString *)resultString;

@end
