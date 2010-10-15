//
//  UICreator.m
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UICreator.h"


@implementation UICreator

+ (UIImage *) getButtonImage
{
	UIImage *image = [UIImage imageNamed:@"whiteButton.png"];	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	
    return newImage;
}

+ (UIImage *) getButtonPressedImage
{
	UIImage *image = [UIImage imageNamed:@"blueButton.png"];	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	
    return newImage;
}

@end
