//
//  FileReaderHelper.h
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StationItem.h"
#import "PriceItem.h"
#import	"Debug.h"
#import "JSON.h"

@interface FileReaderHelper : NSObject {

	NSFileManager *fileManager;
	NSString *documentsDirectory;
}

- (NSArray *)getStationItems;
- (int)numberOfFiles;

@end
