//
//  GoogleDirections.m
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GoogleDirections.h"


@implementation GoogleDirections


- (GDirectionItem *)findRouteFrom:(CLLocationCoordinate2D)origin to:(CLLocationCoordinate2D)destination
{
	NSString *originString;
	if (TARGET_IPHONE_SIMULATOR)
	{
		originString = [NSString stringWithFormat:@"%f,%f", 60.102, 24.734];
	}
	else {
		originString = [NSString stringWithFormat:@"%f,%f", origin.latitude, origin.longitude];
	}
 
	NSString *destinationString = [NSString stringWithFormat:@"%f,%f", destination.latitude, destination.longitude];
	NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=false",
		originString, destinationString];
	
}
@end
