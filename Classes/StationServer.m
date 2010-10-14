//
//  StationServer.m
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StationServer.h"
#import "StationAnnotation.h"
#import "Debug.h"
#import "FileReaderHelper.h"



@implementation StationServer

@synthesize stationArray;

- (NSArray *)stationsForMapRegion:(MKCoordinateRegion)region ofType:(NSInteger)type
{
	NSMutableArray *results = [NSMutableArray arrayWithCapacity:10];
	
	//määrittele alue, jolta löytyneet asemat palautetaan
	NSNumber *latitudeStart = [NSNumber numberWithDouble:region.center.latitude - region.span.latitudeDelta/2.0];
    NSNumber *latitudeStop = [NSNumber numberWithDouble:region.center.latitude + region.span.latitudeDelta/2.0];
    NSNumber *longitudeStart = [NSNumber numberWithDouble:region.center.longitude - region.span.longitudeDelta/2.0];
    NSNumber *longitudeStop = [NSNumber numberWithDouble:region.center.longitude + region.span.longitudeDelta/2.0];
    
	//kutsu servua ja kerää alue
	FileReaderHelper *helper = [[FileReaderHelper alloc] init];
	NSArray *items = [helper getStationItems];
	
	for (StationItem *item in items) {
		StationAnnotation *annotation = [[StationAnnotation alloc] initWithItem:item];
		[results addObject:annotation];
		[annotation release];
	}
	
	return results;
}

-(id)init
{
	if (self = [super init])
	{
		stationArray = [[NSMutableArray arrayWithCapacity:4] retain];
		
		/*
		StationItem *item = [[StationItem alloc] init];
		item.uid = 1;
		item.title = @"Hesan asema";
		item.city = @"Helsinki";
		item.address = @"Mikälie tie 23 C";
		item.company = @"Shell";
		item.date = [NSDate dateWithTimeIntervalSinceNow:0];
		item.latitude = [NSNumber numberWithDouble:60.177];
		item.longitude = [NSNumber numberWithDouble:24.938];
		NSArray *prices = [NSArray arrayWithObjects:
						   [NSNumber numberWithDouble:1.431], 
						   [NSNumber numberWithDouble:1.503], 
						   [NSNumber numberWithDouble:1.122], nil];
		item.prices = prices;
		StationAnnotation *annotation = [[StationAnnotation alloc] initWithItem:item];		
		[stationArray addObject:annotation];
		[annotation release];
		[item release];
		[prices release];
		
		
		item = [[StationItem alloc] init];		
		item.title = @"Espoon asema";
		item.city = @"Espoo";
		item.address = @"Toinen katu 2";
		item.company = @"Teboil";
		item.date = [NSDate dateWithTimeIntervalSinceNow:0];
		item.latitude = [NSNumber numberWithDouble:60.215];
		item.longitude = [NSNumber numberWithDouble:24.658];
		prices = [NSArray arrayWithObjects:
						   [NSNumber numberWithDouble:1.431], 
						   [NSNumber numberWithDouble:1.503], 
						   [NSNumber numberWithDouble:1.122], nil];
		item.prices = prices;
		annotation = [[StationAnnotation alloc] initWithItem:item];
		[stationArray addObject:annotation];
		[annotation release];
		[item release];
		[prices release];
		
		
		item = [[StationItem alloc] init];		
		item.title = @"Lappeen ranta";
		item.city = @"Lappeenranta";
		item.address = @"Joki tie 12";
		item.company = @"Teboil";
		item.date = [NSDate dateWithTimeIntervalSinceNow:10];
		item.latitude = [NSNumber numberWithDouble:61.05];
		item.longitude = [NSNumber numberWithDouble:28.18];
		prices = [NSArray arrayWithObjects:
						   [NSNumber numberWithDouble:1.431], 
						   [NSNumber numberWithDouble:1.503], 
						   [NSNumber numberWithDouble:1.122], nil];
		item.prices = prices;
		annotation = [[StationAnnotation alloc] initWithItem:item];
		[stationArray addObject:annotation];
		[annotation release];
		[item release];
		[prices release];
		
		item = [[StationItem alloc] init];		
		item.title = @"Hämeen linna";
		item.city = @"Hämeenlinna";
		item.address = @"Niin varmaan -tie 12?";
		item.company = @"Teboil";
		item.date = [NSDate dateWithTimeIntervalSinceNow:10];
		item.latitude = [NSNumber numberWithDouble:60.98];
		item.longitude = [NSNumber numberWithDouble:24.46];
		prices = [NSArray arrayWithObjects:
						   [NSNumber numberWithDouble:1.431], 
						   [NSNumber numberWithDouble:1.503], 
						   [NSNumber numberWithDouble:1.122], nil];
		item.prices = prices;
		annotation = [[StationAnnotation alloc] initWithItem:item];
		[stationArray addObject:annotation];
		[annotation release];
		[item release];
		[prices release];
		 */
		
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

@end
