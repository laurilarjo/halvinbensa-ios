//
//  Engine.h
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "StationServer.h"
#import "GoogleDirections.h"


@interface Engine : NSObject {
	
	NSInteger selectedCalculationType;
	NSInteger selectedFuelType; //sama numerointi kuin enum Price95E = 0, jne..
	NSMutableArray *mapAnnotations;
	StationServer *stationServer;
	GoogleDirections *googleDirections;

}

@property (nonatomic) NSInteger selectedCalculationType;
@property (nonatomic) NSInteger selectedFuelType;
@property (nonatomic, retain) NSMutableArray *mapAnnotations;

+ (Engine *) sharedInstance;
- (NSArray *)stationsForMapRegion:(MKCoordinateRegion)region;
- (NSArray *)findRouteFrom:(CLLocationCoordinate2D)origin to:(CLLocationCoordinate2D)destination;

@end
