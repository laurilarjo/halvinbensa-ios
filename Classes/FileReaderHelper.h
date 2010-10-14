//
//  FileReaderHelper.h
//  HalvinBensa
//
//  Created by Lauri Larjo on 10/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileReaderHelper : NSObject {

	NSFileManager *fileManager;
	NSString *documentsDirectory;
}

- (NSArray *)getStationItems;
- (int)numberOfFiles;

@end
