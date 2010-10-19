//
//  Engine.h
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Engine : NSObject {
	
	NSInteger selectedSegment;
	bool show95EPrice;
	bool show98EPrice;
	bool showDieselPrice;

}

@property (nonatomic) NSInteger selectedSegment;
@property (nonatomic) bool show95EPrice;
@property (nonatomic) bool show98EPrice;
@property (nonatomic) bool showDieselPrice;

+ (Engine *) sharedInstance;

@end
