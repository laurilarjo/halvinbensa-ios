//
//  GoogleDirections.h
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "NVPolylineAnnotation.h"
#include "TargetConditionals.h"
#include "JSON.h"
#import "Debug.h"
#import "RegexKitLite.h"


@interface GoogleDirections : NSObject {

}

- (NSArray *)findRouteFrom:(CLLocationCoordinate2D)origin to:(CLLocationCoordinate2D)destination;
- (CLLocationDistance)getDirectDistanceFrom:(CLLocationCoordinate2D)origin to:(CLLocationCoordinate2D)destination;
-(NSMutableArray *)decodePolyLine: (NSMutableString *)encoded;

@end
