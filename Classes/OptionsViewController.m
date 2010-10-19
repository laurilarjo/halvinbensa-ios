//
//  OptionsViewController.m
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OptionsViewController.h"


@implementation OptionsViewController

//palaa takaisin RootControlleriin
- (IBAction)backToPreviousView
{
	[self dismissModalViewControllerAnimated:YES];
}

//asetetaan segment control kohdilleen
- (void)viewWillAppear:(BOOL)animated
{
	NSInteger selected = [Engine sharedInstance].selectedSegment;
	segmentControl.selectedSegmentIndex = selected;
	segmentControl.enabled = NO;
}

//päivitetään enginen arvot kohdalleen
- (IBAction)fuelTypeChanged:(UISegmentedControl *)sender
{
	if (sender == selectedFuelTypeControl)
	{
		[Engine sharedInstance].selectedFuelType = selectedFuelTypeControl.selectedSegmentIndex;
	}
}
	

- (void)viewDidLoad
{
	[super viewDidLoad];
}

- (void)viewDidUnload
{
	
}

- (void)dealloc
{

	[super dealloc];
}

@end
