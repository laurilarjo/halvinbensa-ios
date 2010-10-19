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
- (IBAction)showPriceChanged:(UISwitch *)sender
{
	if (sender == show95EPriceSwitch)
	{
		[Engine sharedInstance].show95EPrice = show95EPriceSwitch.on;
	}
	else if (sender == show98EPriceSwitch)
	{
		[Engine sharedInstance].show98EPrice = show98EPriceSwitch.on;
	}
	else if (sender == showDieselPriceSwitch)
	{
		[Engine sharedInstance].showDieselPrice = showDieselPriceSwitch.on;
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
