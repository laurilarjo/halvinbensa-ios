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
	NSInteger selectedFuelType; //sama numerointi kuin enum Price95E = 0, jne..

}

@property (nonatomic) NSInteger selectedSegment;
@property (nonatomic) NSInteger selectedFuelType;

+ (Engine *) sharedInstance;

@end
