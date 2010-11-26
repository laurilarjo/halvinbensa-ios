//
//  StationReader.m
//  HalvinBensa
//
//  Created by Lauri Larjo on 11/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StationReader.h"


@implementation StationReader

- (NSArray *) getStationItems:(NSString *)resultString
{
		
	NSMutableArray *stations = [NSMutableArray arrayWithCapacity:10];
	
	//JSON parsiminen
	NSArray *dicArray = [resultString JSONValue];
		
	for (NSDictionary *dic in dicArray) {
		
		//muunnetaan StationItem
		StationItem *item = [[StationItem alloc] init];
		[item setValuesForKeysWithDictionary:dic];
		
		//haetaan yritys omasta dicistä		
		NSDictionary *company = [item valueForKey:@"company"];
		item.company = [company valueForKey:@"name"];
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		
		//muunnetaan PriceItem
		NSMutableArray *newPrices = [NSMutableArray arrayWithCapacity:3];
		for (NSDictionary *obj in item.prices) {
			PriceItem *price = [[PriceItem alloc] init];
			[price setValuesForKeysWithDictionary:obj];
			//convert date
			price.updated = [formatter dateFromString:[obj valueForKey:@"updated"]];
			//convert price
			price.price = [NSNumber numberWithDouble:[price.price doubleValue]];
			[newPrices addObject:price];
			[price release];
		}
		item.prices = [NSArray arrayWithArray:newPrices];
		
		[stations addObject:item];
		
		[formatter release];
		[item release];
	}
		

	return stations;
}


@end
