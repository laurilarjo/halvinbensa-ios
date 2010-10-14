//
//  FileReaderHelper.m
//  HalvinBensa
//
//	Tämä on apuluokka, joka avustaa datan lukemisessa sisään tiedostoista.
//	Oikeassa toteutuksessa käytetään suoraan httpn yli JSONia.
//
//  Created by Lauri Larjo on 10/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FileReaderHelper.h"


@implementation FileReaderHelper

- (NSArray *) getStationItems 
{
	CMLog(@"Read stations from file...");
	NSMutableArray *stations = [NSMutableArray arrayWithCapacity:10];
	
	NSError *fileError;
	NSString *contents;
	NSArray *files = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:&fileError];
	for (NSString *file in files) {		
		NSString *filePath = [documentsDirectory stringByAppendingPathComponent:file];
		CMLog(@"filePath: %@", filePath);
		contents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&fileError];
		
		//JSON parsiminen
		CMLog(@"parsing JSON: %@", contents);
		NSDictionary *dic = [contents JSONValue];
		
		//muunnetaan StationItem
		StationItem *item = [[StationItem alloc] init];
		[item setValuesForKeysWithDictionary:dic];
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
		
		//muunnetaan PriceItem
		NSMutableArray *newPrices = [NSMutableArray arrayWithCapacity:3];
		for (NSDictionary *obj in item.prices) {
			PriceItem *price = [[PriceItem alloc] init];
			[price setValuesForKeysWithDictionary:obj];
			//convert date
			price.date = [formatter dateFromString:[obj valueForKey:@"date"]];
			//convert price
			price.price = [NSNumber numberWithDouble:[price.price doubleValue]];
			[newPrices addObject:price];
			[price release];
		}
		item.prices = [NSArray arrayWithArray:newPrices];
				
		[stations addObject:item];
		
		[formatter release];
		[item release];
	}	

	return stations;
}

- (void)writeFile:(StationItem *)item
{

}

- (int) numberOfFiles {
	NSArray *files;
	NSError *fileError;
	files = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:&fileError];
	int result = [files count];
	return result;	
}

# pragma mark -
# pragma mark initializers

- (id) init
{
	if (self = [super init])
	{
		CMLog(@"initializing filereader...");
		fileManager = [[NSFileManager alloc] init];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		documentsDirectory = [paths objectAtIndex:0];
		if (!documentsDirectory) {
			CMLog(@"Documents-kansiota ei löytynyt!");
		}
	}
	return self;
}

@end
