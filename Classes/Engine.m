//
//  Engine.m
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Engine.h"


@implementation Engine

@synthesize selectedCalculationType, selectedFuelType, mapAnnotations;

static Engine *sharedEngine = nil;

+ (Engine *) sharedInstance {
    @synchronized(self) {
        if(sharedEngine == nil) {
            [[self alloc] init];
        }
    }
    return sharedEngine;
}

+ (id) allocWithZone:(NSZone *) zone {
    @synchronized(self) {
        if(sharedEngine == nil) {
            sharedEngine = [super allocWithZone:zone];
            return sharedEngine;
        }
    }
    return nil;
}

- (id)init
{
	if (self = [super init])
	{
		self.mapAnnotations = [NSMutableArray arrayWithCapacity:10];
		stationServer = [[StationServer alloc] init];
		googleDirections = [[GoogleDirections alloc] init];
	}
	return self;	
}

- (NSArray *)stationsForMapRegion:(MKCoordinateRegion)region
{
	return [stationServer stationsForMapRegion:region];
}

- (NSArray *)findRouteFrom:(CLLocationCoordinate2D)origin to:(CLLocationCoordinate2D)destination
{
	return [googleDirections findRouteFrom:origin to:destination];
}

- (id) copyWithZone:(NSZone *)zone {
    return self;
}

- (void)dealloc
{
	[mapAnnotations release];
	[stationServer release];
	[googleDirections release];
	[super dealloc];
}

@end
