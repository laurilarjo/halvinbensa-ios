//
//  StationAnnotation.h
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "StationItem.h"
#import	"PriceItem.h"
#import	"Debug.h"

@interface StationAnnotation : NSObject <MKAnnotation> 
{
	StationItem *dataItem;
	NSString *latitude;
	NSString *longitude;
	NSString *title;
	NSString *subtitle;
	CLLocationDistance distanceToUser; //metreissä
	
	CLLocationCoordinate2D coordinate;
	
}

@property (nonatomic, readonly) StationItem *dataItem;
@property (nonatomic, readonly) NSString *latitude;
@property (nonatomic, readonly) NSString *longitude;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *subtitle;
@property CLLocationDistance distanceToUser;

-(id)initWithItem:(StationItem *)item;
-(double)priceOfType:(NSInteger)index;

@end
