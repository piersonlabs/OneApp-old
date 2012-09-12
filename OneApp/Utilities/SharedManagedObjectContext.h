//
//  SharedManagedObjectContext.h
//  WWeek
//
//  Created by Bhoomesh on 4/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SharedManagedObjectContext : NSObject {

	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (SharedManagedObjectContext *)sharedContext;
- (NSString *)applicationDocumentsDirectory;
- (void) copyDatabaseIfNeeded ;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;

@end
