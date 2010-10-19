//
//  Engine.m
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Engine.h"


@implementation Engine

@synthesize selectedSegment, show95EPrice, 
	show98EPrice, showDieselPrice;

static Engine *sharedEngine = nil;

+ (Engine *) sharedInstance {
    @synchronized(self) {
        if(sharedEngine == nil) {
            [[self alloc] init];
        }
    }
    return sharedEngine;
}

+ (id) allocWithZone:(NSZone *) zone {
    @synchronized(self) {
        if(sharedEngine == nil) {
            sharedEngine = [super allocWithZone:zone];
            return sharedEngine;
        }
    }
    return nil;
}

- (id) copyWithZone:(NSZone *)zone {
    return self;
}

@end
