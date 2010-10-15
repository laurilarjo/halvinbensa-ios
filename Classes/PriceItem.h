//
//  PriceItem.h
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PriceItem : NSObject {

	NSInteger stationId;
	NSString *type;
	NSDate *date;
	NSNumber *price;
	bool uploaded; //ei uploadata tätä nettiin
	
}

@property NSInteger stationId;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSNumber *price;
@property bool uploaded;

@end
