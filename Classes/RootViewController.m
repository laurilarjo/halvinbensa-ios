//
//  RootViewController.m
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"


@implementation RootViewController

@synthesize mapView, mapAnnotations, routeAnnotation,
	detailViewController, optionsViewController, segmentControl;


- (void)gotoStartLocation
{
	
	MKCoordinateRegion newRegion;
	newRegion.center.latitude = 60.21;
	newRegion.center.longitude = 24.80;
	newRegion.span.latitudeDelta = 0.628;
	newRegion.span.longitudeDelta = 1.05;
	
	/* Montrealin polyline-kohta
	MKCoordinateRegion newRegion;
	newRegion.span.longitudeDelta = 0.219727;
	newRegion.span.latitudeDelta = 0.221574;
	newRegion.center.latitude = 45.452424;
	newRegion.center.longitude = -73.662643;
	 */
    [self.mapView setRegion:newRegion animated:YES];
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
	for (StationAnnotation *item in self.mapAnnotations) {
		if (item.distanceToUser < 1.0)
		{
			CLLocationCoordinate2D origin = [[mapView userLocation] location].coordinate;
			CLLocationCoordinate2D destination = item.coordinate;
			CLLocationDistance distance = [googleDirections getDirectDistanceFrom:origin to:destination];
			item.distanceToUser = distance;
		}
	}
	/*
	//Etsitään kaksi lähintä asemaa KESKEN
	NSRange range;
	range.location = 0; range.length = 2;
	NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:range];
	NSArray *closestStations = [NSArray arrayWithArray:[self.mapAnnotations objectsAtIndexes:indexes]];
	for (StationAnnotation *item in self.mapAnnotations) {
		if (item.distanceToUser < closest.distanceToUser)
		{
			closest = item;
		}
	}
	for (StationAnnotation *item in [self mapAnnotations]) {
		
	}
	
	//Seuraavaksi haetaan Googlesta kahden lähimmän reitin pituudet talteen
	for (StationAnnotation *item in [self mapAnnotations]) {
		if (item.distanceToUser < 1.0)
		{
			CLLocationCoordinate2D origin = [[mapView userLocation] location].coordinate;
			CLLocationCoordinate2D destination = item.coordinate;
			CLLocationDistance distance = [[googleDirections findRouteFrom:origin to:destination] doubleValue];
			
			item.distanceToUser = distance;
			
		}
	}
	 */
	
	//Sitten katsotaan onko tämä nyt se lähin NÄKYVISTÄ asemista
	StationAnnotation *closest = [[mapView annotations] objectAtIndex:0];
	for (StationAnnotation *item in [mapView annotations]) {
		if (item.distanceToUser < closest.distanceToUser)
		{
			closest = item;
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


#pragma mark IBActionit	

-(IBAction)showOptionsPage
{
	CMLog(@"showOptions");
	self.optionsViewController.modalPresentationStyle = UIModalPresentationFullScreen;
	self.optionsViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
	
	[self.navigationController presentModalViewController:optionsViewController animated:YES];
	 
}

- (IBAction)calculationTypeChanged
{
	NSInteger selected = segmentControl.selectedSegmentIndex;
	CMLog(@"segment selected: %d", selected);
	[Engine sharedInstance].selectedCalculationType = selected;
	[self refreshMap];
	
}

- (IBAction)refreshMap
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
	CMLog(@"Annotations in storage before: %d", [self.mapAnnotations count]);
	//hae kartalla näkyvät asemat
	NSArray *items = [stationServer stationsForMapRegion:mapView.region];
	
	//kerää uudet asemat omaan muistiin
	for (StationAnnotation *item in items) {
		if (![self.mapAnnotations containsObject:item]) {
			[self.mapAnnotations addObject:item];
		}
	}
	
	//lisää uudet asemat kartalle
	for (StationAnnotation *item in self.mapAnnotations) {
		if (![[mapView annotations] containsObject:item])
			[mapView addAnnotation:item];
	}
	
	//filtteröi pois asemat, joilla ei ole käytetyn bensan hintatietoa
	[self filterStationsBySelectedFuelType];
	
	CMLog(@"Annotations in mapView after: %d", [[mapView annotations] count]);
	CMLog(@"Annotations in storage after: %d", [self.mapAnnotations count]);

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
		if (priceLevel < 0) {
			customPinView.pinColor = MKPinAnnotationColorGreen;
		}
		else if (priceLevel > 0) {
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
	
	googleDirections = [[GoogleDirections alloc] init];	
	stationServer = [[StationServer alloc] init];
	self.mapAnnotations = [NSMutableArray arrayWithCapacity:10];
	
	// create a custom navigation bar button and set it to always says "Back"
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = @"Takaisin";
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release];
		
    self.mapView.mapType = MKMapTypeStandard;   // also MKMapTypeSatellite or MKMapTypeHybrid
	self.mapView.showsUserLocation = YES;
	
	[self gotoStartLocation];	
	
	// a drive from Dorval to Westmount, Quebec, Canada... as generated by Google Earth
	NSArray *points = [NSArray arrayWithObjects:
					   [[[CLLocation alloc] initWithLatitude:45.43894 longitude:-73.7396] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44073 longitude:-73.73998] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44082000000001 longitude:-73.73992] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44382 longitude:-73.74069] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44612 longitude:-73.74122] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44612 longitude:-73.74122] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44628 longitude:-73.74119] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44649 longitude:-73.74106999999999] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44665999999999 longitude:-73.7409] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44665999999999 longitude:-73.7409] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44676 longitude:-73.74073] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44707999999999 longitude:-73.73990000000001] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44748 longitude:-73.73856000000001] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44748 longitude:-73.73856000000001] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44834 longitude:-73.73581] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44857999999999 longitude:-73.73475999999999] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44863000000001 longitude:-73.73417000000001] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44863000000001 longitude:-73.73300999999999] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44795 longitude:-73.7008] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44784 longitude:-73.69398] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44775 longitude:-73.69092000000001] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44743999999999 longitude:-73.68584] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44728 longitude:-73.68165999999999] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44726 longitude:-73.67901999999999] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44713000000001 longitude:-73.67238] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44691 longitude:-73.67075] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44662 longitude:-73.66947] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44555 longitude:-73.66679000000001] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44460999999999 longitude:-73.66426] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.443 longitude:-73.65927000000001] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44249000000001 longitude:-73.65730000000001] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44229 longitude:-73.6563] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44211 longitude:-73.65433] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44192 longitude:-73.65125999999999] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44196999999999 longitude:-73.65013999999999] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44213000000001 longitude:-73.64919] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44232000000001 longitude:-73.64847] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44268999999999 longitude:-73.64754000000001] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44527000000001 longitude:-73.64261] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44895 longitude:-73.63585999999999] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.44991 longitude:-73.63379] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.45045 longitude:-73.63251] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.4542 longitude:-73.62442] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.4547 longitude:-73.62327000000001] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.45536000000001 longitude:-73.62194] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.46158 longitude:-73.61073] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.46158 longitude:-73.61073] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.4634 longitude:-73.60753] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.4634 longitude:-73.60753] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.46362 longitude:-73.60720999999999] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.46447 longitude:-73.60558] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.46541 longitude:-73.60393000000001] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.46653000000001 longitude:-73.60204] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.46685 longitude:-73.60166] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.46720000000001 longitude:-73.60137] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.46754 longitude:-73.60120000000001] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.4682 longitude:-73.60108] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.46870000000001 longitude:-73.60115] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.46922 longitude:-73.60138000000001] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.46972999999999 longitude:-73.60173] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.46996 longitude:-73.60209] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.4703 longitude:-73.60287] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.47117999999999 longitude:-73.60565] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.47163 longitude:-73.60674] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.47163 longitude:-73.60674] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.47236 longitude:-73.60812] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.47339000000001 longitude:-73.6103] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.47339000000001 longitude:-73.6103] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.47407 longitude:-73.60908000000001] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.47581000000001 longitude:-73.60705] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.47895 longitude:-73.60353000000001] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.48116 longitude:-73.60088] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.48517 longitude:-73.59635] autorelease],
					   [[[CLLocation alloc] initWithLatitude:45.48679000000001 longitude:-73.59443] autorelease],
					   nil];
	
	NVPolylineAnnotation *annotation = [[[NVPolylineAnnotation alloc] initWithPoints:points mapView:self.mapView] autorelease];
	self.routeAnnotation = annotation;
	[self.mapView addAnnotation:annotation];
	
}

/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */

/*
- (void)viewDidAppear:(BOOL)animated 
{	
}
*/

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
	[self.mapAnnotations release];
    [super dealloc];
}


@end

