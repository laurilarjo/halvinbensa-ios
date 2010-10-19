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
#import "GoogleDirections.h"
#import "StationAnnotation.h"
#import "DetailViewController.h"
#import "OptionsViewController.h"
#import "StationItem.h"
#import "GDirectionItem.h"
#import "Debug.h"
#import "Engine.h"

@class DetailViewController;
@class OptionsViewController;

@interface RootViewController : UIViewController <MKMapViewDelegate>
{
	MKMapView *mapView;
	DetailViewController *detailViewController;
	OptionsViewController *optionsViewController;
	NSMutableArray *mapAnnotations;
	StationServer *stationServer;
	GoogleDirections *googleDirections;
	UISegmentedControl *segmentControl;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) IBOutlet OptionsViewController *optionsViewController;
@property (nonatomic, retain) NSMutableArray *mapAnnotations;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentControl;

- (IBAction)showOptionsPage;
- (IBAction)segmentChanged;
- (IBAction)refreshMap;

@end
