//
//  StationItem.h
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PriceItem.h"

enum Prices {
	Price95E = 0,
	Price98E,
	PriceDiesel
};

@interface StationItem: NSObject 
{
	NSString *latitude;
	NSString *longitude;
	NSInteger uid;
	NSString *title;
	NSString *company;
	NSString *address;
	NSString *city;
	NSArray *prices; //contains PriceItems
	NSString *resource_uri;

}

@property NSInteger uid;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *company;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSArray *prices;
@property (nonatomic, retain) NSString *resource_uri;

-(id)initWithItem:(StationItem *)item;
- (BOOL)isEqualToStationItem:(StationItem *)other;
@end
