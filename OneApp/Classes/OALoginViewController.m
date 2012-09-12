////////////////////////////////////////////////////////////////////////////////
//
//  OALoginViewController.m
//  OneApp
//
//  Created by Dane Hesseldahl on 8/26/12.
//  Copyright (c) 2012 Pierson Labs. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import "OALoginViewController.h"
#import <QuartzCore/QuartzCore.h>

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation OALoginViewController

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
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.logInView.logInButton.titleLabel.text = @" ";
	[self.logInView.logInButton setTitle:@" " forState:UIControlStateNormal];
	[self.logInView.logInButton setTitle:@" " forState:UIControlStateDisabled];
	[self.logInView.logInButton setTitle:@" " forState:UIControlStateSelected];
	[self.logInView.logInButton setTitle:@" " forState:UIControlStateHighlighted];
	self.logInView.logInButton.enabled = NO;
    [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_sm.png"]]];
    self.logInView.usernameField.background = [UIImage imageNamed:@"field_bg.png"];
    self.logInView.passwordField.background = [UIImage imageNamed:@"field_bg.png"];
    self.logInView.usernameField.textColor = [UIColor blackColor];
    self.logInView.passwordField.textColor = [UIColor blackColor];
	
    [self.logInView.logInButton setBackgroundImage: [UIImage imageNamed:@"btn_login.png"] forState:UIControlStateNormal];
	[self.logInView.logInButton setBackgroundImage: [UIImage imageNamed:@"btn_login_off.png"] forState:UIControlStateDisabled];
    [self.logInView.logInButton setBackgroundImage: [UIImage imageNamed:@"btn_login.png"] forState:UIControlStateHighlighted];
	//[self.logInView.logInButton setTitle:@"test" forState:UIControlStateNormal];
    self.logInView.logInButton.titleLabel.textColor = [UIColor clearColor];
	
    [self.logInView.passwordForgottenButton setImage: [UIImage imageNamed:@"btn_forgot.png"] forState:UIControlStateNormal];
    
    [self.logInView.signUpButton setImage:nil forState:UIControlStateNormal];
    [self.logInView.signUpButton setImage:nil forState:UIControlStateHighlighted];
    [self.logInView.signUpButton setBackgroundImage: [UIImage imageNamed:@"btn_register.png"] forState:UIControlStateNormal];
    [self.logInView.signUpButton setBackgroundImage: [UIImage imageNamed:@"btn_register.png"] forState:UIControlStateHighlighted];
    [self.logInView.signUpButton setTitle:@"" forState:UIControlStateNormal];
    [self.logInView.signUpButton setTitle:@"" forState:UIControlStateHighlighted];
    
    [self.logInView.facebookButton setImage:nil forState:UIControlStateNormal];
    [self.logInView.facebookButton setImage:nil forState:UIControlStateHighlighted];
    [self.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@"facebook_login.png"] forState:UIControlStateNormal];
    [self.logInView.facebookButton setTitle:@"" forState:UIControlStateNormal];
    [self.logInView.facebookButton setTitle:@"" forState:UIControlStateHighlighted];
    
    [self.logInView.twitterButton setImage:nil forState:UIControlStateNormal];
    [self.logInView.twitterButton setBackgroundImage:[UIImage imageNamed:@"twitter_login.png"] forState:UIControlStateNormal];
    [self.logInView.twitterButton setTitle:@"" forState:UIControlStateNormal];
    
    [self.logInView.signUpLabel removeFromSuperview];
    [self.logInView.dismissButton removeFromSuperview];
    [self.logInView.externalLogInLabel removeFromSuperview];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textInputChanged:)
												 name:UITextFieldTextDidChangeNotification
											   object:self.logInView.usernameField];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textInputChanged:)
												 name:UITextFieldTextDidChangeNotification
											   object:self.logInView.passwordField];
}

////////////////////////////////////////////////////////////////////////////////
- (void)textInputChanged:(NSNotification *)note
{
	BOOL enableDoneButton = NO;
	// Check if all the text fields are populated
	// The registration view controller would also check the passwordAgainField
	if (self.logInView.usernameField.text != nil && self.logInView.usernameField.text.length > 0
		&& self.logInView.passwordField.text != nil && self.logInView.passwordField.text.length > 0)
	{
		enableDoneButton = YES;
	}
	
	self.logInView.logInButton.enabled = enableDoneButton; // Set the done button accordingly
}

////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLayoutSubviews
{
    // Set frame for elements
    //[self.logInView.dismissButton setFrame:CGRectMake(10.0f, 10.0f, 87.5f, 45.5f)];
    [self.logInView.logo setFrame:CGRectMake(110, 15, 100, 100)];
    [self.logInView.usernameField setFrame:CGRectMake(25, 130, 270, 30)];
    [self.logInView.passwordField setFrame:CGRectMake(25, 165, 270, 30)];
    [self.logInView.logInButton setFrame:CGRectMake(35, 205, 260, 30)];
    [self.logInView.facebookButton setFrame:CGRectMake(85, 355, 150, 31)];
    [self.logInView.twitterButton setFrame:CGRectMake(85, 390, 150, 31)];
    [self.logInView.signUpButton setFrame:CGRectMake(35, 260, 250, 30)];
    [self.logInView.passwordForgottenButton setFrame:CGRectMake(72, 295, 175, 21)];
    //[self.logInView.facebookButton setFrame:CGRectMake(35.0f, 287.0f, 120.0f, 40.0f)];
    //[self.logInView.twitterButton setFrame:CGRectMake(35.0f+130.0f, 287.0f, 120.0f, 40.0f)];
    //[self.logInView.signUpButton setFrame:CGRectMake(35.0f, 385.0f, 250.0f, 40.0f)];
    //[self.fieldsBackground setFrame:CGRectMake(35.0f, 145.0f, 250.0f, 100.0f)];
}

////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated
{
	//[usernameField becomeFirstResponder];
	[super viewWillAppear:animated];
}

////////////////////////////////////////////////////////////////////////////////
- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
}

////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload
{
    [super viewDidUnload];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.logInView.usernameField];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.logInView.passwordField];
}

-  (void)dealloc
{
	[super dealloc];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.logInView.usernameField];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.logInView.passwordField];
}

////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
