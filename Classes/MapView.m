//
//  MapView.m
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapView.h"
#import "Debug.h"
#import "StationAnnotation.h"
#import "Engine.h"
#import	"NVPolylineAnnotationView.h"


@implementation MapView

@synthesize mapView, routeAnnotation;

- (id) initWithFrame:(CGRect)frame parent:(RootViewController *)controller
{
	self = [super initWithFrame:frame];
	if (self != nil) {
		mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		mapView.showsUserLocation = YES;
		self.mapView.mapType = MKMapTypeStandard;
		[mapView setDelegate:self];
		[self addSubview:mapView];
		parent = controller;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoStartLocation:) name:@"displayRoutePressed" object:nil];
		
		[self gotoStartLocation];
	}
	return self;
}

- (void)gotoStartLocation
{
	MKCoordinateRegion newRegion;
	newRegion.center.latitude = 60.21;
	newRegion.center.longitude = 24.80;
	newRegion.span.latitudeDelta = 0.628;
	newRegion.span.longitudeDelta = 1.05;
	
    [self.mapView setRegion:newRegion animated:YES];
}
- (void)gotoStartLocation:(NSNotification *)note
{
	CMLog(@"called");
	StationItem *item = (StationItem *)[note object];
	CLLocationCoordinate2D coord;
	coord.latitude = [item.latitude doubleValue]; 
	coord.longitude = [item.longitude doubleValue];
	[self addRouteTo:coord];
	
}

- (void)addRouteTo:(CLLocationCoordinate2D)destination;
{
	CLLocationCoordinate2D origin = [mapView userLocation].coordinate;
	NSArray *points = [[Engine sharedInstance] findRouteFrom:origin to:destination];
	NVPolylineAnnotation *route = [[NVPolylineAnnotation alloc] initWithPoints:points mapView:self.mapView];
	self.routeAnnotation = route;
	[self.mapView addAnnotation:route];
}

//Poistetaan näkyvistä ne asemat, joissa ei myydä valittua polttoainetta
- (void)filterStationsBySelectedFuelType
{
	NSInteger selectedFuelType = [Engine sharedInstance].selectedFuelType;
	
	NSMutableArray *removeThese = [NSMutableArray arrayWithCapacity:10];
	for (StationAnnotation *annotation in [self.mapView annotations]) {
		if ([annotation isKindOfClass:[StationAnnotation class]]) { //yrittää muuten kutsua MKUserLocation.priceOfType ja kaatuu	
			if (![annotation priceOfType:selectedFuelType] > 0) {
				[removeThese addObject:annotation];
			}
		}
	}
	
	[self.mapView removeAnnotations:removeThese];
	CMLog(@"stations filtered using fuelType: %d", selectedFuelType);
}

/**
 Hintahaarukasta 25% halpoja, 50% neutraaleja, 25% kalliita.  
 Palautetaan -1 jos halpa, 0 jos neutraali, +1 jos kallis
 */
- (double)priceLevelForItem:(StationAnnotation *)annotation forType:(NSInteger)index
{
	double cheapest = 99;
	double mostExpensive = 0;
	
	//ensin etsitään kallein ja halvin
	for (StationAnnotation *item in mapView.annotations) {
		if ([item isKindOfClass:[StationAnnotation class]])
		{
			double price = [item priceOfType:index];
			if (price < cheapest) {
				cheapest = price;
			}
			if (price > mostExpensive)
				mostExpensive = price;
		}
	}
	
	//CMLog(@"cheapest: %f, mostExpensive: %f", cheapest, mostExpensive);
	
	//lasketaan halvimman ja kalleimman rajat
	double priceGap = mostExpensive - cheapest;
	double quarter = priceGap * 0.025;
	double cheapLimit = cheapest + quarter;
	double expensiveLimit = mostExpensive - quarter;
	
	//palautetaan tulos
	if ([annotation priceOfType:index] < cheapLimit)
		return -1;
	if ([annotation priceOfType:index] > expensiveLimit)
		return +1;
	return 0;
	
}

- (BOOL)closestStation:(StationAnnotation *)annotation
{
	//Ensin lasketaan suoran viivan etäisyydet
	for (StationAnnotation *item in [Engine sharedInstance].mapAnnotations) {
		if (item.distanceToUser < 1.0)
		{
			CLLocationCoordinate2D origin = [[mapView userLocation] location].coordinate;
			CLLocationCoordinate2D destination = item.coordinate;
			CLLocationDistance distance = [[Engine sharedInstance] getDirectDistanceFrom:origin to:destination];
			item.distanceToUser = distance;
		}
	}
		
	//Sitten katsotaan onko tämä nyt se lähin NÄKYVISTÄ asemista
	StationAnnotation *closest = [[mapView annotations] objectAtIndex:0];
	for (StationAnnotation *item in [mapView annotations]) {
		if ([item isKindOfClass:[StationAnnotation class]]) {		
			if (item.distanceToUser < closest.distanceToUser)
			{
				closest = item;
			}
		}
	}
	
	if (closest == annotation) {
		return YES;
	}
	else {
		return NO;
	}
	
	//[closestStations release];
}


#pragma mark Called by RootViewController
- (void)refreshMap
{
	NSArray *oldAnnotations = [self.mapView annotations];
	[self.mapView removeAnnotations:oldAnnotations];
	[mapView.delegate mapView:mapView regionDidChangeAnimated:YES];	 
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)map regionWillChangeAnimated:(BOOL)animated
{
	//myös tämmönen on käytössä..
}

//Tähän tullaan käynnistyksessä kaksi kertaa, sillä alussa siirrytään käyttäjän kohdalle
- (void)mapView:(MKMapView *)map regionDidChangeAnimated:(BOOL)animated
{
	CMLog(@"Annotations in mapView before: %d", [[mapView annotations] count]);
	CMLog(@"Annotations in storage before: %d", [[Engine sharedInstance].mapAnnotations count]);
	
	//haetaan kartalla näkyvät asemat
	NSArray *items = [[Engine sharedInstance] stationsForMapRegion:mapView.region];
	
	//kerää uudet asemat omaan muistiin
	for (StationAnnotation *item in items) {
		if (![[Engine sharedInstance].mapAnnotations containsObject:item]) {
			[[Engine sharedInstance].mapAnnotations addObject:item];
		}
	}
	
	//lisää uudet asemat kartalle
	for (StationAnnotation *item in [Engine sharedInstance].mapAnnotations) {
		if (![[mapView annotations] containsObject:item])
			[mapView addAnnotation:item];
	}
		
	//filtteröi pois asemat, joilla ei ole käytetyn bensan hintatietoa
	[self filterStationsBySelectedFuelType];
	
	CMLog(@"Annotations in mapView after: %d", [[mapView annotations] count]);
	CMLog(@"Annotations in storage after: %d", [[Engine sharedInstance].mapAnnotations count]);
	
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
	
	if ([annotation isKindOfClass:[NVPolylineAnnotation class]]) {
		return [[[NVPolylineAnnotationView alloc] initWithAnnotation:annotation mapView:self.mapView] autorelease];
	}
    
    // if an existing pin view was not available, create one
	static NSString *annotationID = @"annotationID";
	
	MKPinAnnotationView* customPinView = 
	(MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationID];
	if (customPinView == nil)
	{
		customPinView = [[[MKPinAnnotationView alloc] 
						  initWithAnnotation:annotation reuseIdentifier:annotationID] autorelease];
	}
	
	if ([Engine sharedInstance].selectedCalculationType == 0) //byPrice
	{
		//laitetaan hinnan mukaiset värit pinneille
		double priceLevel = [self priceLevelForItem:annotation forType:[Engine sharedInstance].selectedFuelType];
		if (priceLevel < 0) { //halpa
			customPinView.pinColor = MKPinAnnotationColorGreen;
		}
		else if (priceLevel > 0) { //kallis
			customPinView.pinColor = MKPinAnnotationColorRed;
		}
		else {
			customPinView.pinColor = MKPinAnnotationColorPurple;
		}
	}
	
	if ([Engine sharedInstance].selectedCalculationType == 1) //byDistance
	{
		if ([self closestStation:annotation]) {
			customPinView.pinColor = MKPinAnnotationColorGreen;			
		}
		else {
			customPinView.pinColor = MKPinAnnotationColorRed;
		}
		
	}
	
	customPinView.animatesDrop = NO;
	customPinView.canShowCallout = YES;
	
	UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	customPinView.rightCalloutAccessoryView = rightButton;
	
	return customPinView;
}

//käyttäjä valitsi jonkun pinnin
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
	//[self addRouteTo:view.annotation.coordinate];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	StationAnnotation *annotation = view.annotation;	
	CMLog(@"Valitsi: %@", annotation.title);
	[parent showDetailsWithData:annotation.dataItem]; //varoittaa ihan turhaan?
	
}


@end
