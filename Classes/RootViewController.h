//
//  RootViewController.h
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "StationServer.h"
#import "StationAnnotation.h"
#import "DetailViewController.h"
#import "StationItem.h"
#import "Debug.h"

@class DetailViewController;

@interface RootViewController : UIViewController <MKMapViewDelegate>
{
	MKMapView *mapView;
	DetailViewController *detailViewController;
	NSMutableArray *mapAnnotations;
	StationServer *stationServer;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) NSMutableArray *mapAnnotations;

@end
