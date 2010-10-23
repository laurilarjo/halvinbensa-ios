//
//  RootViewController.m
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"


@implementation RootViewController

@synthesize mapView, detailViewController, optionsViewController, segmentControl;


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
	[mapView refreshMap];
}

- (void)showDetailsWithData:(StationItem *)item
{
	self.detailViewController.currentStation = item;
	[self.navigationController pushViewController:self.detailViewController animated:YES];
}



#pragma mark ViewController stuff

//ensin ladataan xib, sitten tullaan tänne
- (void)viewDidLoad 
{
	[super viewDidLoad];
	
	//tekee just sopivan kokoisen mapviewn, jotta alapalkki näkyy kokonaan
	CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height-87));
	mapView = [[[MapView alloc] initWithFrame:frame parent:self] autorelease];
	
	[self.view addSubview:mapView];
	
	// create a custom navigation bar button and set it to always says "Back"
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = @"Takaisin";
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release];
	
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
	self.mapView = nil;
	self.detailViewController = nil;
}


- (void)dealloc {
	[mapView release];
	[detailViewController release];
    [super dealloc];
}


@end

