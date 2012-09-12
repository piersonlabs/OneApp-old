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

@synthesize tagTextField = _tagTextField;
@synthesize photoPostBackgroundTaskId = _photoPostBackgroundTaskId;

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
	
	CGRect passwordTextFieldFrame = CGRectMake(20.0f, 20.0f, 280.0f, 180.0f);
	[self setQuestionTextField:[[UITextField alloc] initWithFrame:passwordTextFieldFrame]];
	[self questionTextField].placeholder = @"Ask a Question";
	[self questionTextField].backgroundColor = [UIColor whiteColor];
	[self questionTextField].textColor = [UIColor blackColor];
	[self questionTextField].font = [UIFont systemFontOfSize:14.0f];
	[self questionTextField].borderStyle = UITextBorderStyleRoundedRect;
	[self questionTextField].clearButtonMode = UITextFieldViewModeWhileEditing;
	[self questionTextField].returnKeyType = UIReturnKeyDone;
	[self questionTextField].textAlignment = UITextAlignmentLeft;
	[self questionTextField].contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	[self questionTextField].delegate = self;
	[self questionTextField].autocapitalizationType = UITextAutocapitalizationTypeNone;
	[[self questionTextField] setValue:[UIColor colorWithRed:154.0f/255.0f green:146.0f/255.0f blue:138.0f/255.0f alpha:1.0f] forKeyPath:@"_placeholderLabel.textColor"];
	[self.view addSubview:[self questionTextField]];
	
	[self setTagTextField:[[UITextField alloc] initWithFrame:CGRectMake( 20.0f, 210.0f, 280.0f, 31.0f)]];
	[self tagTextField].font = [UIFont systemFontOfSize:14.0f];
	[self tagTextField].placeholder = @"Tag this question";
	[self tagTextField].returnKeyType = UIReturnKeySend;
	[self tagTextField].textColor = [UIColor colorWithRed:73.0f/255.0f green:55.0f/255.0f blue:35.0f/255.0f alpha:1.0f];
	[self tagTextField].contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	[self tagTextField].autocapitalizationType = UITextAutocapitalizationTypeNone;
	[self tagTextField].borderStyle = UITextBorderStyleRoundedRect;
	[self tagTextField].delegate = self;
	[[self tagTextField] setValue:[UIColor colorWithRed:154.0f/255.0f green:146.0f/255.0f blue:138.0f/255.0f alpha:1.0f] forKeyPath:@"_placeholderLabel.textColor"];
	[self.view addSubview:[self tagTextField]];
	
	UIButton *btn_ask = [UIButton buttonWithType:UIButtonTypeCustom];
	[btn_ask setFrame:CGRectMake(35, 260, 260, 30)];
	[btn_ask setTitle:@"Login" forState:UIControlStateNormal];
	[btn_ask setImage:[UIImage imageNamed:@"btn_ask.png"] forState:UIControlStateNormal];
	[btn_ask addTarget:self action:@selector(askQuestionClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btn_ask];
	
}

#pragma mark - UITextFieldDelegate

////////////////////////////////////////////////////////////////////////////////
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //[self askQuestionClick:textField];
    [textField resignFirstResponder];
    return YES;
}

////////////////////////////////////////////////////////////////////////////////
-(void)askQuestionClick:(id)sender
{
	//NSDictionary *userInfo = [NSDictionary dictionary];
    NSString *trimmedComment = [self.questionTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
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
    //[photo setObject:self.thumbnailFile forKey:kPAPPhotoThumbnailKey];
    
    // Photos are public, but may only be modified by the user who uploaded them
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
	
	//PUSH NOTIFICATIONS
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
