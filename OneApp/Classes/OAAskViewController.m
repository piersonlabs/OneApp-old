////////////////////////////////////////////////////////////////////////////////
//
//  OAAskViewController.m
//  OneApp
//
//  Created by Dane Hesseldahl on 9/10/12.
//  Copyright (c) 2012 Pierson Labs. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import "OAAskViewController.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation OAAskViewController

////////////////////////////////////////////////////////////////////////////////
- (id)init
{
    self = [super init];
    if (self)
	{
		[self setTitle:@"Ask A Question"];

    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	QSection *section = [[QSection alloc] init];
	[section setTitle:@"Your Question"];
	
	QEntryElement *question = [[QEntryElement alloc] initWithTitle:@"" Value:@""];
	question.key = @"question";
	question.height = 180.0f;
	[section addElement:question];
	
	QSection *sectionCat = [[QSection alloc] init];
	[sectionCat setTitle:@"Category"];
	
	NSArray *categoryTemp = [NSArray arrayWithObjects:@"Politics", @"Entertainment", @"Food", @"News", nil];
	QRadioElement *categoryElement = [[QRadioElement alloc] initWithItems:categoryTemp selected:2];
	categoryElement.key = @"category";
	[sectionCat addElement:categoryElement];
	
	QSection *subSection = [[QSection alloc] init];
	QButtonElement *button = [[QButtonElement alloc] init];
	button.title = @"Ask Question";
	button.controllerAction = @"onAsk:";
	[subSection addElement:button];
	
	[self.root addSection:section];
	[self.root addSection:sectionCat];
	[self.root addSection:subSection];
}



#pragma mark - Form Delegate Methods

////////////////////////////////////////////////////////////////////////////////
- (void)onAsk:(QButtonElement *)buttonElement
{
	NSMutableDictionary* info = [[NSMutableDictionary alloc] init];
	[self.root fetchValueIntoObject:info];
	NSLog(@"BUTTON PRESSED: %@", info);
	
	NSString *trimmedComment = [[info valueForKey:@"question"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	if (trimmedComment.length == 0)
	{
		NSLog(@"Question failed to post: Blank Question");
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Question cannot be blank" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
		[alert show];
		return;
	}
	
	// Create a question object
    PFObject *question = [PFObject objectWithClassName:kOAQuestionClassKey];
    [question setObject:[PFUser currentUser] forKey:kOAQuestionUserKey];
    [question setObject:trimmedComment forKey:kOAQuestionTextKey];
	[question setObject:@"user" forKey:kOAQuestionTypeKey];
	[question setObject:[info objectForKey:@"category"] forKey:kOAQuestionCategoryKey];
    //[photo setObject:self.thumbnailFile forKey:kPAPPhotoThumbnailKey];
    
    // questions are public, but may only be modified by the user who uploaded them
    PFACL *questionACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [questionACL setPublicReadAccess:YES];
    question.ACL = questionACL;
	
	// save
    [question saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
	 {
		 if (succeeded)
		 {
			 NSLog(@"Saved User Question [User: %@]: %@",[PFUser currentUser], trimmedComment);
			 
			 [[OACache sharedCache] setAttributesForPhoto:question likers:[NSArray array] commenters:[NSArray array] likedByCurrentUser:NO];
			 //[[NSNotificationCenter defaultCenter] postNotificationName:PAPTabBarControllerDidFinishEditingPhotoNotification object:photo];
		 }
		 else
		 {
			 NSLog(@"Question failed to post: %@", error);
			 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your question" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
			 [alert show];
		 }
		 
		 [[UIApplication sharedApplication] endBackgroundTask:self.photoPostBackgroundTaskId];
	 }];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:QuestionAskedNotification object: nil];
	
	// PUSH NOTIFICATIONS
	// refresh cache
	/*
	 NSMutableSet *channelSet = [NSMutableSet setWithCapacity:self.objects.count];
	 
	 // set up this push notification to be sent to all commenters, excluding the current  user
	 for (PFObject *comment in self.objects) {
	 PFUser *author = [comment objectForKey:kPAPActivityFromUserKey];
	 NSString *privateChannelName = [author objectForKey:kPAPUserPrivateChannelKey];
	 if (privateChannelName && privateChannelName.length != 0 && ![[author objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
	 [channelSet addObject:privateChannelName];
	 }
	 }
	 [channelSet addObject:[self.photo objectForKey:kPAPPhotoUserKey]];
	 
	 if (channelSet.count > 0) {
	 NSString *alert = [NSString stringWithFormat:@"%@: %@", [PAPUtility firstNameForDisplayName:[[PFUser currentUser] objectForKey:kPAPUserDisplayNameKey]], trimmedComment];
	 
	 // make sure to leave enough space for payload overhead
	 if (alert.length > 100) {
	 alert = [alert substringToIndex:99];
	 alert = [alert stringByAppendingString:@"…"];
	 }
	 
	 NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
	 alert, kAPNSAlertKey,
	 kPAPPushPayloadPayloadTypeActivityKey, kPAPPushPayloadPayloadTypeKey,
	 kPAPPushPayloadActivityCommentKey, kPAPPushPayloadActivityTypeKey,
	 [[PFUser currentUser] objectId], kPAPPushPayloadFromUserObjectIdKey,
	 [self.photo objectId], kPAPPushPayloadPhotoObjectIdKey,
	 @"Increment",kAPNSBadgeKey,
	 nil];
	 PFPush *push = [[PFPush alloc] init];
	 [push setChannels:[channelSet allObjects]];
	 [push setData:data];
	 [push sendPushInBackground];
	 }
	 */
}


////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
