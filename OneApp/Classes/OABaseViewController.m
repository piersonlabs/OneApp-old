////////////////////////////////////////////////////////////////////////////////
//
//  OABaseViewControllerViewController.m
//  OneApp
//
//  Created by Dane Hesseldahl on 8/8/12.
//  Copyright (c) 2012 Pierson Labs. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import "OABaseViewController.h"
#import "OARegisterViewController.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation OABaseViewController

@synthesize navigationController = _navigationController;
@synthesize state = _state;
@synthesize stateNext = _stateNext;
@synthesize loginView = _loginView;
@synthesize questionView = _questionView;
@synthesize resultsView = _resultsView;
@synthesize settingsView = _settingsView;
@synthesize drawer = _drawer;
@synthesize askView = _askView;
@synthesize findFriendsView = _findFriendsView;
@synthesize autoFollowTimer = _autoFollowTimer;
@synthesize loader = _loader;
@synthesize activityIndicator = _activityIndicator;

////////////////////////////////////////////////////////////////////////////////
- (id)init
{
    self = [super init];
    if (self) 
    {
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    //[_resultsView release];
    //[_questionView release];
    //[_navigationController release];
    [super dealloc];
}

////////////////////////////////////////////////////////////////////////////////
- (void)loadView 
{
    [super loadView];
    
    [self setView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_FULL_WIDTH, APP_FULL_HEIGHT)]];
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    [self setLoginView:[[OALoginViewController alloc] init]];
    [[self loginView] setFacebookPermissions:[NSArray arrayWithObjects:@"publish_actions,user_location,user_photos,email,friends_about_me,friends_location", nil]];
    [[self loginView] setFields: PFLogInFieldsDefault | PFLogInFieldsTwitter | PFLogInFieldsFacebook ];
    
    // Customize the Sign Up View Controller
    OARegisterViewController *signUpViewController = [[OARegisterViewController alloc] init];
    [signUpViewController setDelegate:self];
    [signUpViewController setFields:PFSignUpFieldsDefault | PFLogInFieldsTwitter | PFLogInFieldsFacebook ];
    [[self loginView] setSignUpController:signUpViewController];
    
    [self setQuestionView:[[QuestionsTableViewController alloc] initWithStyle:UITableViewStylePlain]];
    [self setResultsView:[[ResultsTableViewController alloc] initWithStyle:UITableViewStylePlain]];
    [self setSettingsView:[[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped]];
	[self setAskView:[[OAAskViewController alloc] init]];

    [self setDrawer:[[OADrawerView alloc] initWithFrame:CGRectMake(0, 500, 320, 170)]];
	[self drawer].delegate = self;
	[self drawer].hidden = YES;
	[self.view addSubview:[self drawer]];
    
    if([PFUser currentUser])
    {
		[self showLoader];
        [self setNavigationController:[[UINavigationController alloc] initWithRootViewController:[self questionView]]];
		[self logInViewController:self.loginView didLogInUser:[PFUser currentUser]];
    }
    else 
    {
        [self setNavigationController:[[UINavigationController alloc] initWithRootViewController:[self loginView]]];
        [self hideNavigationBar];
    }

    [self navigationController].navigationBar.barStyle = UIBarStyleBlack;
    [self.view insertSubview:[self navigationController].view belowSubview:[self drawer]];
	
	//create notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showQuestionAfterAsk) name:QuestionAskedNotification object:nil];
}

////////////////////////////////////////////////////////////////////////////////
- (void) showLoader
{
	[self setLoader: [[UIView alloc] initWithFrame: CGRectMake(0,0,APP_FULL_WIDTH, APP_FULL_HEIGHT)]];
	[[self loader] setBackgroundColor: [UIColor colorWithWhite:0 alpha:0.6]];
	
	[self setActivityIndicator:[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]];
	[self activityIndicator].frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
	[self activityIndicator].center = self.view.center;
	[[self loader] addSubview: [self activityIndicator]];
	
	[[self activityIndicator] startAnimating];
	[self.view addSubview:[self loader]];
	[self.view bringSubviewToFront:[self loader]];
}

////////////////////////////////////////////////////////////////////////////////
- (void) hideLoader
{
	[UIView animateWithDuration:1
						  delay: 0.5
						options: UIViewAnimationCurveLinear
					 animations:^{
						 //[self menuView].alpha = 1.0;
						 [self loader].alpha = 0;
					 }
					 completion:^(BOOL finished){
						 if([self activityIndicator].isAnimating)
						 {
							 [[self activityIndicator] stopAnimating];
							 [[self activityIndicator] release];
							 [self.loader removeFromSuperview];
                             //[_loaderLabel release];
                             //_loaderLabel = nil;
							 [_loader release];
                             _loader = nil;
						 }
					 }];
	
    
}

////////////////////////////////////////////////////////////////////////////////
-(void)hideNavigationBar 
{    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

////////////////////////////////////////////////////////////////////////////////
-(void)showNavigationBar
{    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Child View Functions

////////////////////////////////////////////////////////////////////////////////
-(void)showQuestions
{
    [[self navigationController] setViewControllers:[NSArray arrayWithObject:[self questionView]] animated:YES];
    [self hideDrawer];
    [self setState:@"questions"];
}

////////////////////////////////////////////////////////////////////////////////
-(void)showQuestionAfterAsk
{
	[self showLoader];
    [[self navigationController] setViewControllers:[NSArray arrayWithObject:[self questionView]] animated:YES];
    [self hideDrawer];
    [self setState:@"questions"];
	[self.questionView loadObjects];
	[self hideLoader];
}

////////////////////////////////////////////////////////////////////////////////
-(void)showResults
{
	[PFUser logOut];
    [[self navigationController] setViewControllers:[NSArray arrayWithObject:[self loginView]] animated:YES];
    [self hideDrawer];
    [self hidehandle];
    [self hideNavigationBar];
    [self setState:@"settings"];
    //[[self navigationController] setViewControllers:[NSArray arrayWithObject:[self resultsView]] animated:YES];
    //[self hideDrawer];
    //[self setState:@"results"];
}

////////////////////////////////////////////////////////////////////////////////
-(void)showAsk
{
    [[self navigationController] setViewControllers:[NSArray arrayWithObject:[self askView]] animated:YES];
    [self hideDrawer];
    [self setState:@"ask"];
}

////////////////////////////////////////////////////////////////////////////////
-(void)showSettings
{
	[self setFindFriendsView:[[OAFindFriendsViewController alloc] init ]];
	[[self navigationController] setViewControllers:[NSArray arrayWithObject:[self findFriendsView]] animated:YES];
    [self hideDrawer];
    [self setState:@"frenz"];
}

////////////////////////////////////////////////////////////////////////////////
- (void) logout
{
	[PFUser logOut];
    [[self navigationController] setViewControllers:[NSArray arrayWithObject:[self loginView]] animated:YES];
    [self hideDrawer];
    [self hidehandle];
    [self hideNavigationBar];
    [self setState:@"settings"];
}

#pragma mark - Login Functions

////////////////////////////////////////////////////////////////////////////////
-(void)showLogin
{	
	//[self.loginView hideLoader];
	[self setState:@"login"];
}

#pragma mark - Logout button handler

//////////////////////////////////////////////////////////////////////////////
- (IBAction)logOutButtonTapAction:(id)sender 
{
    [PFUser logOut];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - PFLogInViewControllerDelegate

//////////////////////////////////////////////////////////////////////////////
// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password 
{
    if (username && password && username.length && password.length) 
    {
        return YES;
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information" message:@"Make sure you fill out all of the information!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
    return NO;
}

//////////////////////////////////////////////////////////////////////////////
// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
	[[PFFacebookUtils facebook] requestWithGraphPath:@"me/?fields=name,picture" andDelegate:self];
	
    // Subscribe to private push channel
    if (user)
	{
        NSString *privateChannelName = [NSString stringWithFormat:@"user_%@", [user objectId]];
        [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:kOAInstallationUserKey];
        [[PFInstallation currentInstallation] addUniqueObject:privateChannelName forKey:kOAInstallationChannelsKey];
        [[PFInstallation currentInstallation] saveEventually];
        [user setObject:privateChannelName forKey:kOAUserPrivateChannelKey];
    }
	
	[self.findFriendsView loadObjects];
}

//////////////////////////////////////////////////////////////////////////////
// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error 
{
    NSLog(@"Failed to log in...");
}

//////////////////////////////////////////////////////////////////////////////
// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController 
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - PF_FBRequestDelegate

//////////////////////////////////////////////////////////////////////////////
- (void)request:(PF_FBRequest *)request didLoad:(id)result
{
    // This method is called twice - once for the user's /me profile, and a second time when obtaining their friends. We will try and handle both scenarios in a single method.
    
    NSArray *data = [result objectForKey:@"data"];
    //NSLog(@"PF_FBRequest: %@", data);
    if (data)
	{
        // we have friends data
        NSMutableArray *facebookIds = [[NSMutableArray alloc] initWithCapacity:[data count]];
        for (NSDictionary *friendData in data)
		{
            [facebookIds addObject:[friendData objectForKey:@"id"]];
        }
		
        // cache friend data
        [[OACache sharedCache] setFacebookFriends:facebookIds];
		
		
        //if (![[PFUser currentUser] objectForKey:kOAUserAlreadyAutoFollowedFacebookFriendsKey])
		if(1)
		{
            //[self.hud setLabelText:@"Following Friends"];
            NSLog(@"Auto-following");
            firstLaunch = YES;
            
            [[PFUser currentUser] setObject:[NSNumber numberWithBool:YES] forKey:kOAUserAlreadyAutoFollowedFacebookFriendsKey];
            NSError *error = nil;
            
			//NSLog(@"Looking at FB Friends: %@", facebookIds);
            
			// find common Facebook friends already using Anypic
            PFQuery *facebookFriendsQuery = [PFUser query];
            [facebookFriendsQuery whereKey:kOAUserFacebookIDKey containedIn:facebookIds];
            NSArray *anypicFriends = [facebookFriendsQuery findObjects:&error];
			
            if (!error)
			{
                [anypicFriends enumerateObjectsUsingBlock:^(PFUser *newFriend, NSUInteger idx, BOOL *stop)
				{
                    NSLog(@"Join activity for %@", [newFriend objectForKey:kOAUserDisplayNameKey]);
                    PFObject *joinActivity = [PFObject objectWithClassName:kOAActivityClassKey];
                    [joinActivity setObject:[PFUser currentUser] forKey:kOAActivityFromUserKey];
                    [joinActivity setObject:newFriend forKey:kOAActivityToUserKey];
                    [joinActivity setObject:kOAActivityTypeJoined forKey:kOAActivityTypeKey];
					
                    PFACL *joinACL = [PFACL ACL];
                    [joinACL setPublicReadAccess:YES];
                    joinActivity.ACL = joinACL;
					
                    // make sure our join activity is always earlier than a follow
                    [joinActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
					{
                        if (succeeded)
						{
                            NSLog(@"Followed %@", [newFriend objectForKey:kOAUserDisplayNameKey]);
                        }

                        [OAUtility followUserInBackground:newFriend block:^(BOOL succeeded, NSError *error)
						{
                            // This block will be executed once for each friend that is followed.
                            // We need to refresh the timeline when we are following at least a few friends
                            // Use a timer to avoid refreshing innecessarily
                            if (self.autoFollowTimer)
							{
                                [self.autoFollowTimer invalidate];
                            }
							
                            self.autoFollowTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(autoFollowTimerFired:) userInfo:nil repeats:NO];
                        }];
                    }];
                }];
            }
            
            if (![self shouldProceedToMainInterface:[PFUser currentUser]])
			{
                //[self logOut];
                return;
            }

			
            if (!error)
			{
				/*
                [MBProgressHUD hideHUDForView:self.navController.presentedViewController.view animated:NO];
				 */
                if (anypicFriends.count > 0)
				{
                    //self.hud = [MBProgressHUD showHUDAddedTo:self.homeViewController.view animated:NO];
                    //[self.hud setDimBackground:YES];
                    //[self.hud setLabelText:@"Following Friends"];
                }
				else
				{
                    //[self.homeViewController loadObjects];
                }				
            }
			
			[self.findFriendsView loadObjects];
			[self showNavigationBar];
			[self showHandle];
			[self showQuestions];
			[self hideLoader];
			NSLog(@"Showing interface");
        }
        
        [[PFUser currentUser] saveEventually];
    }
	else
	{
		NSLog(@"Creating Profile");
        //[self.hud setLabelText:@"Creating Profile"];
        NSString *facebookId = [result objectForKey:@"id"];
        NSString *facebookName = [result objectForKey:@"name"];
        
        if (facebookName && facebookName != 0)
		{
            [[PFUser currentUser] setObject:facebookName forKey:kOAUserDisplayNameKey];
        }
		
        if (facebookId && facebookId != 0)
		{
            [[PFUser currentUser] setObject:facebookId forKey:kOAUserFacebookIDKey];
        }
        
        [[PFFacebookUtils facebook] requestWithGraphPath:@"me/friends" andDelegate:self];
    }
}

//////////////////////////////////////////////////////////////////////////////
- (void)request:(PF_FBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Facebook error: %@", error);
    
    if ([PFUser currentUser])
	{
        if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
             isEqualToString: @"OAuthException"])
		{
            NSLog(@"The facebook token was invalidated");
            //[self logOut];
        }
    }
}

//////////////////////////////////////////////////////////////////////////////
- (void)autoFollowTimerFired:(NSTimer *)aTimer
{
    //[MBProgressHUD hideHUDForView:self.navController.presentedViewController.view animated:YES];
    //[MBProgressHUD hideHUDForView:self.homeViewController.view animated:YES];
    //[self.homeViewController loadObjects];
	
	[self.findFriendsView loadObjects];
}

//////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldProceedToMainInterface:(PFUser *)user
{
    if ([OAUtility userHasValidFacebookData:[PFUser currentUser]])
	{
        //[MBProgressHUD hideHUDForView:self.navController.presentedViewController.view animated:YES];
        //[self presentTabBarController];
		
        //[self.navController dismissModalViewControllerAnimated:YES];
        return YES;
    }
    
    return NO;
}

//////////////////////////////////////////////////////////////////////////////
- (BOOL)handleActionURL:(NSURL *)url
{
    if ([[url host] isEqualToString:kOALaunchURLHostTakePicture])
	{
        if ([PFUser currentUser])
		{
            //return [self.tabBarController shouldPresentPhotoCaptureController];
        }
    }
	
    return NO;
}

#pragma mark - PFSignUpViewControllerDelegate

//////////////////////////////////////////////////////////////////////////////
// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info 
{
    BOOL informationComplete = YES;
    for (id key in info)
	{
        NSString *field = [info objectForKey:key];
    
		if (!field || field.length == 0)
        {
            informationComplete = NO;
            break;
        }
    }
    
    if (!informationComplete)
	{
        [[[UIAlertView alloc] initWithTitle:@"Missing Information" message:@"Make sure you fill out all of the information!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

//////////////////////////////////////////////////////////////////////////////
// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user 
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//////////////////////////////////////////////////////////////////////////////
// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error 
{
    NSLog(@"Failed to sign up...");
}

//////////////////////////////////////////////////////////////////////////////
// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController 
{
    NSLog(@"User dismissed the signUpViewController");
}

#pragma mark - Drawer Functions

////////////////////////////////////////////////////////////////////////////////
- (void)showDrawer
{	
	[self drawer].frame = CGRectMake(0, 423, 320, 170);
	
	[UIView animateWithDuration:0.3
						  delay: 0.0
						options: UIViewAnimationCurveEaseIn
					 animations:^{
						 [self drawer].frame = CGRectMake(0, 314, 320, 170);
					 }
					 completion:^(BOOL finished){
					 }];
}

////////////////////////////////////////////////////////////////////////////////
- (void)hideDrawer
{
	[self drawer].frame = CGRectMake(0, 314, 320, 170);
	
	[UIView animateWithDuration:0.5
						  delay: 0.0
						options: UIViewAnimationCurveLinear
					 animations:^{
						 [self drawer].frame = CGRectMake(0, 443, 320, 170);
					 }
					 completion:^(BOOL finished){
					 }];
}

////////////////////////////////////////////////////////////////////////////////
- (void)showHandle
{
	[self drawer].hidden = NO;
	[self drawer].frame = CGRectMake(0, 500, 320, 170);
	[self.view bringSubviewToFront:[self drawer]];
	
	[UIView animateWithDuration:0.5
						  delay: 0.3
						options: UIViewAnimationCurveLinear
					 animations:^{
						 [self drawer].frame = CGRectMake(0, 443, 320, 170);
					 }
					 completion:^(BOOL finished){
					 }];
}

////////////////////////////////////////////////////////////////////////////////
- (void)hidehandle
{
	//[self drawer].frame = CGRectMake(0, 423, 320, 170);
	
	[UIView animateWithDuration:0.5
						  delay: 0.0
						options: UIViewAnimationCurveLinear
					 animations:^{
						 [self drawer].frame = CGRectMake(0, 500, 320, 170);
					 }
					 completion:^(BOOL finished){
						 [self drawer].hidden = YES;
					 }];
}

////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [_resultsView release];
    [_questionView release];
    [_navigationController release];
    
    [super viewDidLoad];
}

////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload
{
    [super viewDidUnload];
}

////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
