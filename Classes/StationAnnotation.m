//
//  StationAnnotation.m
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StationAnnotation.h"


@implementation StationAnnotation

@synthesize dataItem, distanceToUser;

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

- (double)priceOfType:(NSInteger)index
{
	double result = [[[dataItem.prices objectAtIndex:index] price] doubleValue];
	return result;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToStationAnnotation:other];	
}

- (BOOL)isEqualToStationAnnotation:(StationAnnotation *)other
{
	if (other == self)
		return YES;
	if (!other || ![other isKindOfClass:[self class]])
		return NO;
	if (![self.dataItem isEqual:other.dataItem])
		return NO;
	return YES;
	
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
