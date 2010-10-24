//
//  GoogleDirections.m
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GoogleDirections.h"


@implementation GoogleDirections

- (CLLocationDistance)getDirectDistanceFrom:(CLLocationCoordinate2D)origin to:(CLLocationCoordinate2D)destination
{
	CLLocation *originLoc;
	if (TARGET_IPHONE_SIMULATOR)
	{
		originLoc = [[CLLocation alloc] initWithLatitude:60.102 longitude:24.734];
	}
	else {
		originLoc = [[CLLocation alloc] initWithLatitude:origin.latitude longitude:origin.longitude];
	}

	CLLocation *destinationLoc = [[CLLocation alloc] initWithLatitude:destination.latitude longitude:destination.longitude];
	CLLocationDistance distance = [originLoc distanceFromLocation:destinationLoc];
	CMLog(@"Direct distance: %f", distance);
	return distance;
}

//distancen hakeminen toimii, mutta on liian hidas. yksi haku kestää melkein sekunnin.
- (NSArray *)findRouteFrom:(CLLocationCoordinate2D)origin to:(CLLocationCoordinate2D)destination
{
	CMLog(@"Calculating distance...");
	NSString *originString;
	if (TARGET_IPHONE_SIMULATOR)
	{
		originString = [NSString stringWithFormat:@"%f,%f", 60.102, 24.734];
	}
	else {
		originString = [NSString stringWithFormat:@"%f,%f", origin.latitude, origin.longitude];
	}
 
	NSString* daddr = [NSString stringWithFormat:@"%f,%f", destination.latitude, destination.longitude];
	
	NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%@&daddr=%@", originString, daddr];
	NSURL* apiUrl = [NSURL URLWithString:apiUrlStr];
	CMLog(@"Google Maps API url: %@", apiUrl);
	NSString *apiResponse = [NSString stringWithContentsOfURL:apiUrl];
	NSString* encodedPoints = [apiResponse stringByMatching:@"points:\\\"([^\\\"]*)\\\"" capture:1L];
	
	return [self decodePolyLine:[encodedPoints mutableCopy]];
}

-(NSMutableArray *)decodePolyLine: (NSMutableString *)encoded {
	[encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
								options:NSLiteralSearch
								  range:NSMakeRange(0, [encoded length])];
	NSInteger len = [encoded length];
	NSInteger index = 0;
	NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
	NSInteger lat=0;
	NSInteger lng=0;
	while (index < len) {
		NSInteger b;
		NSInteger shift = 0;
		NSInteger result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lat += dlat;
		shift = 0;
		result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lng += dlng;
		NSNumber *latitude = [[[NSNumber alloc] initWithFloat:lat * 1e-5] autorelease];
		NSNumber *longitude = [[[NSNumber alloc] initWithFloat:lng * 1e-5] autorelease];
		printf("[%f,", [latitude doubleValue]);
		printf("%f]", [longitude doubleValue]);
		CLLocation *loc = [[[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]] autorelease];
		[array addObject:loc];
	}
	
	return array;
}

@end
