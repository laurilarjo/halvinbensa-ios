//
//  MapView.h
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "NVPolylineAnnotation.h"
#import "StationServer.h"


@class RootViewController;


@interface MapView : UIView<MKMapViewDelegate> {

	RootViewController *parent;
	MKMapView *mapView;
	NVPolylineAnnotation *routeAnnotation;
	NSMutableArray *mapAnnotations;
	StationServer *stationServer;
}
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) NVPolylineAnnotation *routeAnnotation;
@property (nonatomic, retain) NSMutableArray *mapAnnotations;

- (id) initWithFrame:(CGRect)frame parent:(RootViewController *)controller;
- (void)addRoute:(NSArray *)points;
- (void)refreshMap;
- (void)gotoStartLocation;

@end
