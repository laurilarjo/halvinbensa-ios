//
//  UpdatePriceViewController.m
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UpdatePriceViewController.h"
#import	"Debug.h"

@implementation UpdatePriceViewController

@synthesize euroPickerView, centPickerView;

-(IBAction)accept:(UIButton *)sender
{
	CMLog(@"accepted");
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

- (void)dealloc
{
	[euroPickerView release];
	[centPickerView release];
	[super dealloc];
}

@end
