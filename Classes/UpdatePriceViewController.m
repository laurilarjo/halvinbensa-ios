//
//  UpdatePriceViewController.m
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UpdatePriceViewController.h"

@implementation UpdatePriceViewController

@synthesize euroPickerView, centPickerView, currentPriceItem;

-(IBAction)accept:(UIButton *)sender
{
	NSInteger value1 = [euroPickerView selectedRowInComponent:0];
	NSInteger value2 = [centPickerView selectedRowInComponent:0];
	NSInteger value3 = [centPickerView selectedRowInComponent:1];
	NSInteger value4 = [centPickerView selectedRowInComponent:2];
	NSString *string = [NSString stringWithFormat:@"%d.%d%d%d", 
						value1, value2, value3, value4];
	CMLog(@"Accepted new price: %@", string);
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UIPickerViewDelegate

#pragma mark UIPickerViewDataSource

- (NSString *)pickerView:(UIPickerView *)pickerView 
			 titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [[NSNumber numberWithInt:row] stringValue];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return 10;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	if (pickerView == self.euroPickerView) {
		return 1;
	}
	else //centPickerView
	{
		return 3;
	}
}

#pragma mark ViewController stuff

- (void)viewDidLoad
{
	[super viewDidLoad];
	
}

- (void)viewDidUnload
{
	self.euroPickerView = nil;
	self.centPickerView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	double dvalue = [[currentPriceItem price] doubleValue];
	if (dvalue > 10)
	{
		CMLog(@"PRICE WAS OVER 10!!");
		return;
	}
	
	//string on muotoa 1.423
	NSString *string = [NSString stringWithFormat:@"%.3f", dvalue];
	
	//asetetaan vanha hintateksti
	oldPriceLabel.text = string;
	
	NSString *value1 = [NSString stringWithFormat:@"%c", [string characterAtIndex:0]];
	NSString *value2 = [NSString stringWithFormat:@"%c", [string characterAtIndex:2]];
	NSString *value3 = [NSString stringWithFormat:@"%c", [string characterAtIndex:3]];
	NSString *value4 = [NSString stringWithFormat:@"%c", [string characterAtIndex:4]];
	
	//asetetaan rullat valitun hinnan arvoihin
	[euroPickerView selectRow:[value1 intValue] inComponent:0 animated:NO];
	[centPickerView selectRow:[value2 intValue] inComponent:0 animated:NO];
	[centPickerView selectRow:[value3 intValue] inComponent:1 animated:NO];
	[centPickerView selectRow:[value4 intValue] inComponent:2 animated:NO];
	
}

- (void)dealloc
{
	[euroPickerView release];
	[centPickerView release];
	[super dealloc];
}

@end
