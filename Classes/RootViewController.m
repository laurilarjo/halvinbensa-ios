//
//  RootViewController.m
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"


@implementation RootViewController

@synthesize mapView, mapAnnotations, detailViewController;


- (void)gotoStartLocation
{
	MKCoordinateRegion newRegion;
	newRegion.center.latitude = 60.21;
	newRegion.center.longitude = 24.80;
	newRegion.span.latitudeDelta = 0.628;
	newRegion.span.longitudeDelta = 1.05;
	
    [self.mapView setRegion:newRegion animated:YES];
}



#pragma mark -
#pragma mark MKMapViewDelegate


- (void)mapView:(MKMapView *)map regionWillChangeAnimated:(BOOL)animated
{
	//myös tämmönen on käytössä..
}

- (void)mapView:(MKMapView *)map regionDidChangeAnimated:(BOOL)animated
{
	NSArray *items = [stationServer stationsForMapRegion:mapView.region ofType:1];
	
	
    NSArray *oldAnnotations = mapView.annotations;
    [mapView removeAnnotations:oldAnnotations];	    
	[mapView addAnnotations:items];
	
	
	//tehdään saumaton operaatio, jolla ei tule merkkien välkkymistä kartalle
	//jos löytyy molemmista, ei tehdä mitään
	//jos löytyy vain itemsistä, (item ei löydy annotationsista), lisätään
	//jos löytyy vain annotationsista (annotation ei löyty itemsistä), poistetaan
	
	/* TODO: TÄÄ EI NYT IHAN TOIMI, tulee SIGABRTtia
	for (StationAnnotation *item in items) {
		if (![[mapView annotations] containsObject:item]) {
			[mapView addAnnotation:item];
		}
	}
	NSArray *oldAnnotations = mapView.annotations;
	for (StationAnnotation *item in oldAnnotations) {
		if (![items containsObject:item]) {
			[mapView removeAnnotation:item];
		}
	}
	 */
	 

}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;   
    
    // if an existing pin view was not available, create one
	static NSString *annotationID = @"annotationID";
	
	MKPinAnnotationView* customPinView = 
		(MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationID];
	if (customPinView == nil)
	{
		customPinView = [[[MKPinAnnotationView alloc]  initWithAnnotation:annotation reuseIdentifier:annotationID] autorelease];
	}
	customPinView.pinColor = MKPinAnnotationColorRed;
	customPinView.animatesDrop = NO;
	customPinView.canShowCallout = YES;
	
	// add a detail disclosure button to the callout which will open a new view controller page
	//
	// note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
	//  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
	//
	UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	customPinView.rightCalloutAccessoryView = rightButton;
	
	return customPinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	StationAnnotation *annotation = view.annotation;
	CMLog(@"Valitsi: %@", annotation.title);
	self.detailViewController.currentStation = annotation.dataItem;
	[self.navigationController pushViewController:self.detailViewController animated:YES];
}


#pragma mark ViewController stuff

- (void)viewDidLoad 
{
	[super viewDidLoad];
	
	// create a custom navigation bar button and set it to always says "Back"
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = @"Takaisin";
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release];
	
	stationServer = [[StationServer alloc] init];
    self.mapView.mapType = MKMapTypeStandard;   // also MKMapTypeSatellite or MKMapTypeHybrid
	self.mapView.showsUserLocation = YES;
	
	self.mapAnnotations = [[NSMutableArray alloc] initWithCapacity:2];	
	//[mapView addAnnotations:stationServer.stationArray];
	
	[self gotoStartLocation];	
	
}

/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */

- (void)viewDidAppear:(BOOL)animated 
{	
}

/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    self.mapAnnotations = nil;
	self.mapView = nil;
	self.detailViewController = nil;
}


- (void)dealloc {
	[mapView release];
	[detailViewController release];
	[mapAnnotations release];
    [super dealloc];
}


@end

