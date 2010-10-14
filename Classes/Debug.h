//
//  Debug.h
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#define DEBUG_LOG 1

// Helpful macros provided by Stephen Burlos, http://blog.coriolis.ch/2009/01/05/macros-for-xcode/
#ifdef DEBUG_LOG
#define CMLog(format, ...) NSLog(@"%s:%@", __PRETTY_FUNCTION__,[NSString stringWithFormat:format, ## __VA_ARGS__]);
#define MARK	CMLog(@"%s", __PRETTY_FUNCTION__);
#define START_TIMER NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
#define END_TIMER(msg) 	NSTimeInterval stop = [NSDate timeIntervalSinceReferenceDate]; CMLog([NSString stringWithFormat:@"%@ Time = %f", msg, stop-start]);
#else
#define CMLog(format, ...)
#define MARK
#define START_TIMER
#define END_TIMER(msg)
#endif