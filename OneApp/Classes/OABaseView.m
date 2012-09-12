////////////////////////////////////////////////////////////////////////////////
//
//  OABaseView.m
//  OneApp
//
//  Created by Dane Hesseldahl on 8/8/12.
//  Copyright (c) 2012 Pierson Labs. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import "OABaseView.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation OABaseView

////////////////////////////////////////////////////////////////////////////////
@synthesize loader = _loader;
@synthesize activityIndicator = _activityIndicator;
@synthesize delegate;

////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////
- (void) saveCoreData
{
	NSManagedObjectContext *smoc = [[SharedManagedObjectContext sharedContext] managedObjectContext];
	NSError *error = nil;
	
	if(![smoc save:&error]) 
	{
		NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
		NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
		if(detailedErrors != nil && [detailedErrors count] > 0) 
		{
			for(NSError* detailedError in detailedErrors) 
			{
				NSLog(@"  DetailedError: %@", [detailedError userInfo]);
			}
		}
		else 
		{
			NSLog(@"  %@", [error userInfo]);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////
- (void) showLoader
{	
	[self setLoader: [[UIView alloc] initWithFrame: CGRectMake(0,0,APP_FULL_WIDTH, APP_FULL_HEIGHT)]];
	[[self loader] setBackgroundColor: [UIColor colorWithWhite:0 alpha:0.6]];
	
	[self setActivityIndicator:[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]];
	[self activityIndicator].frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
	[self activityIndicator].center = self.center;
	[[self loader] addSubview: [self activityIndicator]];
	
	[[self activityIndicator] startAnimating];
	[self addSubview:[self loader]];
	[self bringSubviewToFront:[self loader]];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
