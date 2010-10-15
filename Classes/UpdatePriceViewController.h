//
//  UpdatePriceViewController.h
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "PriceItem.h"
#import	"UICreator.h"
#import	"Debug.h"

@interface UpdatePriceViewController : UIViewController {
	
	IBOutlet UIButton *acceptButton;
	IBOutlet UILabel *oldPriceLabel;
	IBOutlet UIPickerView *euroPickerView;
	IBOutlet UIPickerView *centPickerView;
	PriceItem *currentPriceItem;
}

@property (nonatomic, retain) UIPickerView *euroPickerView;
@property (nonatomic, retain) UIPickerView *centPickerView;
@property (nonatomic, retain) PriceItem *currentPriceItem;

-(IBAction)accept:(UIButton *)sender;

@end
