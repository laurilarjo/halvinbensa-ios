//
//  StationServer.h
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "StationAnnotation.h"
#import "Debug.h"
#import "FileReaderHelper.h"

@interface StationServer : NSObject 
{
	NSMutableArray *stationArray;
}

@property (nonatomic, retain) NSMutableArray *stationArray;

- (NSArray *)stationsForMapRegion:(MKCoordinateRegion)region ofType:(NSInteger)type;

@end
