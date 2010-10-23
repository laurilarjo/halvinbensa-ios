//
//  RootViewController.h
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "OptionsViewController.h"
#import "MapView.h"
#import "Debug.h"
#import "Engine.h"

@class DetailViewController;
@class OptionsViewController;

@interface RootViewController : UIViewController <MKMapViewDelegate>
{
	MapView *mapView;
	DetailViewController *detailViewController;
	OptionsViewController *optionsViewController;
	UISegmentedControl *segmentControl;
}

@property (nonatomic, retain) IBOutlet MapView *mapView;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) IBOutlet OptionsViewController *optionsViewController;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentControl;

- (IBAction)showOptionsPage;
- (IBAction)calculationTypeChanged;
- (IBAction)refreshMap;
- (void)showDetailsWithData:(StationItem *)item;

@end
