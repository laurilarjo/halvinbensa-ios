//
//  StationItem.m
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StationItem.h"


@implementation StationItem

@synthesize uid, latitude, longitude, title, company,
	address, city, prices, resource_uri;


- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToStationItem:other];	
}

- (BOOL)isEqualToStationItem:(StationItem *)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    if (uid != other.uid)
		return NO;
	if (![latitude isEqualToString:other.latitude])
		return NO;
	if (![longitude isEqualToString:other.longitude])
		return NO;
	if (![title isEqualToString:other.title])
		return NO;
	if (![company isEqualToString:other.company])
		return NO;
	if (![address isEqualToString:other.address])
		return NO;
	if (![city isEqualToString:other.city])
		return NO;
	if (![resource_uri isEqualToString:other.resource_uri])
		return NO;
	return YES;
}

-(id)initWithItem:(StationItem *)item
{
	if (self = [super init])
	{
		uid = item.uid;
		[self setLatitude:item.latitude];
		[self setLongitude:item.longitude];
		[self setTitle:item.title];
		[self setCompany:item.company];
		[self setAddress:item.address];
		[self setCity:item.city];
		[self setPrices:item.prices];
		[self setResource_uri:item.resource_uri];

	}
	return self;
}

- (void) dealloc
{
	[latitude release];
	[longitude release];
	[title release];
	[company release];
	[address release];
	[city release];
	[prices release];
	[resource_uri release];
	[super dealloc];
}

@end
