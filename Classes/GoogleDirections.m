//
//  GoogleDirections.m
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GoogleDirections.h"


@implementation GoogleDirections


//distancen hakeminen toimii, mutta on liian hidas. yksi haku kestää melkein sekunnin.
- (NSNumber *)findRouteFrom:(CLLocationCoordinate2D)origin to:(CLLocationCoordinate2D)destination
{
	NSString *originString;
	if (TARGET_IPHONE_SIMULATOR)
	{
		originString = [NSString stringWithFormat:@"%f,%f", 60.102, 24.734];
	}
	else {
		originString = [NSString stringWithFormat:@"%f,%f", origin.latitude, origin.longitude];
	}
 
	NSString *destinationString = [NSString stringWithFormat:@"%f,%f", destination.latitude, destination.longitude];
	NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=false",
		originString, destinationString];
	
	NSURL *url = [NSURL URLWithString:urlString];
	
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	
	NSString *result = nil;
	BOOL success = NO;
	int retryCount = 0;
	
	while (success == false && retryCount < 2) {
		NSHTTPURLResponse *response = nil;
		NSError *error = nil;
		NSData *responseData = 
		[NSURLConnection sendSynchronousRequest:request returningResponse:&response
										  error:&error];
		
		result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
		
		CMLog(@"Response Code: %d", [response statusCode]);
		if ([response statusCode] >= 200 && [response statusCode] < 300)
		{
			CMLog(@"Result: %@", result);
			success = YES;
		}
		retryCount++;

	}
	//[request release];
	//[url release];
	
	//JSON Framework magic to obtain a dictionary from the jsonString.
    NSDictionary *results = [result JSONValue];
	
    //kaivetaan sieltä distance
    NSArray *routes  = [results objectForKey:@"routes"];
	NSArray *legs = [[routes objectAtIndex:0] objectForKey:@"legs"];
	NSNumber *distance = [[legs objectAtIndex:0] valueForKeyPath:@"distance.value"];
	
	return distance;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	//The string received from google's servers
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
    //JSON Framework magic to obtain a dictionary from the jsonString.
    NSDictionary *results = [jsonString JSONValue];
	
    //Now we need to obtain our coordinates
    NSArray *routes  = [results objectForKey:@"routes"];
	NSArray *legs = [[routes objectAtIndex:0] objectForKey:@"legs"];
	NSString *distance = [[legs objectAtIndex:0] objectForKey:@"distance"];
   //NSArray *legs = [[placemark objectAtIndex:0] valueForKeyPath:@"Point.coordinates"];
	
    	
    //Debug.
    //NSLog(@"Latitude - Longitude: %f %f", latitude, longitude);
	
	
    [jsonString release];
}

@end
