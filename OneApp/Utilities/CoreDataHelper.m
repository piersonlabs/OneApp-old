//
//  Created by Björn Sållarp on 2009-06-14.
//  NO Copyright 2009 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//

#import "CoreDataHelper.h"


@implementation CoreDataHelper


+(NSMutableArray *) searchObjectsInContext: (NSString*) entityName : (NSPredicate *) predicate : (NSString*) sortKey : (BOOL) sortAscending : (NSManagedObjectContext *) managedObjectContext
{

	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];	
	[request setReturnsObjectsAsFaults:NO];
//	[request setRelationshipKeyPathsForPrefetching:[NSArray arrayWithObject:@"Event"]];
	// If a predicate was passed, pass it to the query
	if(predicate != nil)
	{
		[request setPredicate:predicate];
	}
	
	// If a sort key was passed, use it for sorting.
	if(sortKey != nil)
	{
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:sortAscending];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		[request setSortDescriptors:sortDescriptors];
		[sortDescriptors release];
		[sortDescriptor release];
	}
	
	NSError *error;
	
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	
	[request release];
	
	return mutableFetchResults;
}

+(NSMutableArray *) getObjectsFromContext: (NSString*) entityName : (NSString*) sortKey : (BOOL) sortAscending : (NSManagedObjectContext *) managedObjectContext
{
	return [self searchObjectsInContext:entityName :nil :sortKey :sortAscending :managedObjectContext];
}

@end
