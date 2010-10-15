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


- (double)priceOfIndex:(NSInteger)index
{
	if (index >= 0 && index < [currentStation.prices count]) {
		return [[[currentStation.prices objectAtIndex:index] price] doubleValue];
	}
	
	CMLog(@"ERROR: index out of bounds: %d", index);
	return 0;
	
}

- (void)confirmPrice:(UIButton *)sender
{
	if (sender == confirm95EButton)
	{
		PriceItem *item = [currentStation.prices objectAtIndex:Price95E];
		CMLog(@"95E confirmed: %.3f", [item.price doubleValue]);
		//TODO: uploadaa
		[self priceUploaded:item];
	}
	if (sender == confirm98EButton)
	{
		PriceItem *item = [currentStation.prices objectAtIndex:Price98E];
		CMLog(@"98E confirmed: %.3f", [item.price doubleValue]);
		//uploadaa
		[self priceUploaded:item];
	}
	if (sender == confirmDieselButton)
	{
		PriceItem *item = [currentStation.prices objectAtIndex:PriceDiesel];
		CMLog(@"Diesel confirmed: %.3f", [item.price doubleValue]);
		//ploadaa
		[self priceUploaded:item];
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

- (void)priceUploaded:(PriceItem *)item
{
	CMLog(@"%@ uploaded", item.type);
	item.uploaded = YES;
	NSInteger index = [currentStation.prices indexOfObject:item];
	switch (index) {
		case Price95E:
			confirm95EButton.hidden = YES;
			change95EButton.hidden = YES;
			updatedPrice95ELabel.hidden = NO;
			break;
		case Price98E:
			confirm98EButton.hidden = YES;
			change98EButton.hidden = YES;
			updatedPrice98ELabel.hidden = NO;
			break;
		case PriceDiesel:
			confirmDieselButton.hidden = YES;
			changeDieselButton.hidden = YES;
			updatedPriceDieselLabel.hidden = NO;
			break;
		default:
			break;
	}
}

#pragma mark ViewController stuff

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	//lisätään taustakuvat nappulalle, jota ei voi Interface Builderissa tehdä oikein
	UIImage *buttonImage = [UICreator getButtonImage];
	[showRouteButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
	
	UIImage *buttonPressedImage = [UICreator getButtonPressedImage];
	[showRouteButton setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
}

- (void)viewDidAppear:(BOOL)animated
{
	
}

- (void)viewWillAppear:(BOOL)animated
{
	//osittain ehkä turha, jos karttaa liikuttaa niin nää itemit ladataan uudestaan
	if ([[currentStation.prices objectAtIndex:Price95E] uploaded]) {
		updatedPrice95ELabel.hidden = NO;
		confirm95EButton.hidden = YES;
		change95EButton.hidden = YES;
	}
	else
	{
		updatedPrice95ELabel.hidden = YES;
		confirm95EButton.hidden = NO;
		change95EButton.hidden = NO;
	}
	if ([[currentStation.prices objectAtIndex:Price98E] uploaded]) {
		updatedPrice98ELabel.hidden = NO;
		confirm98EButton.hidden = YES;
		change98EButton.hidden = YES;
	}
	else
	{
		updatedPrice98ELabel.hidden = YES;
		confirm98EButton.hidden = NO;
		change98EButton.hidden = NO;
	}
	if ([[currentStation.prices objectAtIndex:PriceDiesel] uploaded]) {
		updatedPriceDieselLabel.hidden = NO;
		confirmDieselButton.hidden = YES;
		changeDieselButton.hidden = YES;
	}
	else
	{
		updatedPriceDieselLabel.hidden = YES;
		confirmDieselButton.hidden = NO;
		changeDieselButton.hidden = NO;
	}
	
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
