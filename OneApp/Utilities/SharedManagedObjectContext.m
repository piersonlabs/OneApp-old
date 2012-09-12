//
//  SharedManagedObjectContext.m
//  WWeek
//
//  Created by Bhoomesh on 4/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SharedManagedObjectContext.h"
#import <CoreData/CoreData.h>

static SharedManagedObjectContext *sharedContext = nil;

@implementation SharedManagedObjectContext

+ (SharedManagedObjectContext *)sharedContext
{
	if(sharedContext)
        return sharedContext;

	@synchronized(self)
	{
		if (!sharedContext)
		{
			sharedContext = [[SharedManagedObjectContext alloc] init];
		}		
	}
	return sharedContext;
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	//[self copyDatabaseIfNeeded];
	// Complete url to our database file
	NSString *databaseFilePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"FivePlates.sqlite"];
	
	// if you make changes to your model and a database already exist in the app
	// you'll get a NSInternalInconsistencyException exception. When the model i updated 
	// the databasefile must be removed. I'll always remove the database here becuase it is simple.
	/*NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtPath:databaseFilePath error:NULL];
	
	if([fileManager fileExistsAtPath:databaseFilePath])
	{
		[fileManager removeItemAtPath:databaseFilePath error:nil];
	}*/
	
    NSURL *storeUrl = [NSURL fileURLWithPath: databaseFilePath];	
	
	/* Start Change Dane 09/01/10 *
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:databaseFilePath]) 
	{
		NSLog(@"FIRST RUN - PRELOADING DATABASE FROM MAIN BUNDLE");
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"PreloadPre1" ofType:@"sqlite"];
		
		if (defaultStorePath) 
		{
			[fileManager copyItemAtPath:defaultStorePath toPath:databaseFilePath error:NULL];
		}
	}
	* End Change Dane */
	
	NSError *error;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        // Handle error
    }    
	
    return persistentStoreCoordinator;
}

#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	NSLog(@"1");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSLog(@"2");
    return basePath;
}

- (void) copyDatabaseIfNeeded {
	
	//Using NSFileManager we can perform many file system operations.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath1 = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Pre1.sqlite"];
	BOOL success = [fileManager fileExistsAtPath:dbPath1]; 
	
	if(!success) {
		
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Pre1.sqlite"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath1 error:&error];
		//	NSLog(@"%@",defaultDBPath);
		if (!success) 
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}	
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (sharedContext == nil) {
            sharedContext = [super allocWithZone:zone];
            return sharedContext;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
	[self managedObjectContext];
	
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
} 

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

@end
