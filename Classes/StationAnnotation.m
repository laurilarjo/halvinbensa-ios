//
//  StationAnnotation.m
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StationAnnotation.h"
#import "StationItem.h"
#import	"PriceItem.h"
#import	"Debug.h"


@implementation StationAnnotation

@synthesize dataItem;

- (CLLocationCoordinate2D)coordinate;
{
	coordinate.latitude = [dataItem.latitude doubleValue];
    coordinate.longitude = [dataItem.longitude doubleValue];
    return coordinate; 
}

- (NSString *)title
{
	NSString *result = dataItem.title;
	return result;
	
}

- (NSString *)subtitle
{	
	NSString *result = [NSString stringWithFormat:@"95E: %.3f 98E: %.3f Diesel: %.3f", 
						[[[dataItem.prices objectAtIndex:Price95E] price] doubleValue],
						[[[dataItem.prices objectAtIndex:Price98E] price] doubleValue],
						[[[dataItem.prices objectAtIndex:PriceDiesel] price] doubleValue]];
	return result;
}

- (NSString *)latitude
{
	NSString *result = dataItem.latitude;
	return result;
}

- (NSString *)longitude
{
	NSString *result = dataItem.longitude;
	return result;
}

- (id)init
{	
	if (self = [super init])
	{
		CMLog(@"TÄTÄ EI PIDÄ KÄYTTÄÄ");
		dataItem = [[StationItem alloc] init];
	}
	return self;
	
}

-(id)initWithItem:(StationItem *)item
{
	if (self = [super init])
	{
		CMLog(@"Creating new annotation");
		dataItem = [[StationItem alloc] initWithItem:item];
	}
	return self;
}

- (void) dealloc
{
	CMLog(@"Deleting annotation.");
	[dataItem release];
	[super dealloc];
}

@end
