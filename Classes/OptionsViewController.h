//
//  OptionsViewController.h
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Engine.h"

@interface OptionsViewController : UIViewController {

	IBOutlet UIBarButtonItem *showOptionsButton;
	IBOutlet UISegmentedControl *selectedFuelTypeControl;
	IBOutlet UISegmentedControl *selectedCalculationTypeControl;
}

- (IBAction)backToPreviousView;
- (IBAction)fuelTypeChanged:(UISegmentedControl *)sender;
@end
