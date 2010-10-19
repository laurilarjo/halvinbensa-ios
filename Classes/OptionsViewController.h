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
	IBOutlet UISwitch *show95EPriceSwitch;
	IBOutlet UISwitch *show98EPriceSwitch;
	IBOutlet UISwitch *showDieselPriceSwitch;
	IBOutlet UISegmentedControl *segmentControl;
}

- (IBAction)backToPreviousView;
- (IBAction)showPriceChanged:(UISwitch *)sender;
@end
