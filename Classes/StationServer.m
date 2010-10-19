//
//  StationServer.m
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StationServer.h"

@implementation StationServer

@synthesize stationArray;


//Palauttaa StationAnnotation-arrayn kartalla näkyvistä asemista
- (NSArray *)stationsForMapRegion:(MKCoordinateRegion)region
{
	NSMutableArray *results = [NSMutableArray arrayWithCapacity:10];
	
	//määrittele alue, jolta löytyneet asemat palautetaan
	//NSNumber *latitudeStart = [NSNumber numberWithDouble:region.center.latitude - region.span.latitudeDelta/2.0];
    //NSNumber *latitudeStop = [NSNumber numberWithDouble:region.center.latitude + region.span.latitudeDelta/2.0];
    //NSNumber *longitudeStart = [NSNumber numberWithDouble:region.center.longitude - region.span.longitudeDelta/2.0];
    //NSNumber *longitudeStop = [NSNumber numberWithDouble:region.center.longitude + region.span.longitudeDelta/2.0];
    
	//kutsu servua ja kerää alue
	FileReaderHelper *helper = [[FileReaderHelper alloc] init];
	NSArray *items = [helper getStationItems];
	
	for (StationItem *item in items) {
		StationAnnotation *annotation = [[StationAnnotation alloc] initWithItem:item];
		[results addObject:annotation];
		[annotation release];
	}
	[helper release];
	
	return results;
}

//mahdollisesti parametrina myös doneSelector ja errorSelector (kts. esim. mealtrackerin EPUploader
- (void)updatePrice:(PriceItem *)item
{
	//uploadataan uusi hinta servulle
}

-(id)init
{
	if (self = [super init])
	{
		stationArray = [[NSMutableArray arrayWithCapacity:4] retain];
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

@end
