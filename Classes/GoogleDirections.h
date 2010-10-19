//
//  GoogleDirections.h
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "GDirectionItem.h"
#include "TargetConditionals.h"


@interface GoogleDirections : NSObject {

}

- (GDirectionItem *)findRouteFrom:(CLLocationCoordinate2D)origin to:(CLLocationCoordinate2D)destination;

@end
