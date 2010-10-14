//
//  DetailViewController.m
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController

@synthesize updatePriceViewController, currentStation;


- (void)confirmPrice:(UIButton *)sender
{
	if (sender == confirm95EButton)
	{
		CMLog(@"95E confirmed");
	}
	if (sender == confirm98EButton)
	{
		CMLog(@"98E confirmed");
	}
	if (sender == confirmDieselButton)
	{
		CMLog(@"Diesel confirmed");
	}
}

- (void)changePrice:(UIButton *)sender 
{
	if (sender == change95EButton)
	{
		self.updatePriceViewController.currentPriceItem = 
			[currentStation.prices objectAtIndex:Price95E];
		CMLog(@"95E UpdatePrice->");	
	}
	if (sender == change98EButton)
	{
		self.updatePriceViewController.currentPriceItem = 
		[currentStation.prices objectAtIndex:Price98E];
		CMLog(@"98E UpdatePrice->");	
	}
	if (sender == changeDieselButton)
	{
		self.updatePriceViewController.currentPriceItem = 
		[currentStation.prices objectAtIndex:PriceDiesel];
		CMLog(@"Diesel UpdatePrice->");	
	}
	
	[self.navigationController pushViewController:self.updatePriceViewController animated:YES];
	
}

#pragma mark ViewController stuff

- (void)viewDidLoad
{
	[super viewDidLoad];		
	CMLog(@"didLoad");
}

- (void)viewDidAppear:(BOOL)animated
{
	CMLog(@"didAppear");
	
}

- (void)viewWillAppear:(BOOL)animated
{
	CMLog(@"willAppear");
	titleLabel.text = currentStation.title;
	addressLabel.text = currentStation.address;
	price95ELabel.text = [NSString stringWithFormat:@"%.3f", 
				[[[currentStation.prices objectAtIndex:Price95E] price] doubleValue]];
	price98ELabel.text = [NSString stringWithFormat:@"%.3f",
				[[[currentStation.prices objectAtIndex:Price98E] price] doubleValue]];
	priceDieselLabel.text = [NSString stringWithFormat:@"%.3f",
				[[[currentStation.prices objectAtIndex:PriceDiesel] price] doubleValue]];
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];	
	[formatter setDateFormat:@"d.M.Y"];
	//TODO: nyt näyttää vain 95E:n päiväyksen
	NSDate *date = [[currentStation.prices objectAtIndex:Price95E] date];
	dateLabel.text = [formatter stringFromDate:date];
	[formatter release];
}

- (void)viewDidUnload
{
	updatePriceViewController = nil;
	currentStation = nil;
}

- (void)dealloc
{
	[currentStation release];
	[updatePriceViewController release];
	[super dealloc];
}

@end
