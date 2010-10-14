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
	address, city, prices;

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
		/*
		longitude = [item.longitude copy];
		title = [item.title copy];
		company = [item.company copy];
		address = [item.address copy];
		city = [item.city copy];
		prices = [item.prices copy];
		 */
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
	[super dealloc];
}

@end
