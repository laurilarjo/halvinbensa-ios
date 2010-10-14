//
//  UpdatePriceViewController.h
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UpdatePriceViewController : UIViewController {
	
	IBOutlet UIPickerView *euroPickerView;
	IBOutlet UIPickerView *centPickerView;
}

@property (nonatomic, retain) UIPickerView *euroPickerView;
@property (nonatomic, retain) UIPickerView *centPickerView;

-(IBAction)accept:(UIButton *)sender;

@end
