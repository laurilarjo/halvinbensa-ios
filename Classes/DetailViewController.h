//
//  DetailViewController.h
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "StationItem.h"
#import "PriceItem.h"
#import "UpdatePriceViewController.h"
#import	"UICreator.h"
#import "Debug.h"

@class UpdatePriceViewController;

@interface DetailViewController : UIViewController 
{
	UpdatePriceViewController *updatePriceViewController;
	StationItem *currentStation;
	
	IBOutlet UILabel *titleLabel;
	IBOutlet UILabel *addressLabel;
	IBOutlet UILabel *price95ELabel;
	IBOutlet UILabel *price98ELabel;
	IBOutlet UILabel *priceDieselLabel;
	IBOutlet UILabel *dateLabel;
	IBOutlet UIButton *showRouteButton;
	
	IBOutlet UIButton *confirm95EButton;
	IBOutlet UIButton *confirm98EButton;
	IBOutlet UIButton *confirmDieselButton;
	IBOutlet UIButton *change95EButton;
	IBOutlet UIButton *change98EButton;
	IBOutlet UIButton *changeDieselButton;
	
	IBOutlet UILabel *updatedPrice95ELabel;
	IBOutlet UILabel *updatedPrice98ELabel;
	IBOutlet UILabel *updatedPriceDieselLabel;
}

@property (nonatomic, retain) IBOutlet UpdatePriceViewController *updatePriceViewController;
@property (nonatomic, retain) StationItem *currentStation;
- (IBAction)confirmPrice:(UIButton *)sender;
- (IBAction)changePrice:(UIButton *)sender;
- (IBAction)priceUploaded:(PriceItem *)item;

@end
