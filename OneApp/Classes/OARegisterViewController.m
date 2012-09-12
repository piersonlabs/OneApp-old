////////////////////////////////////////////////////////////////////////////////
//
//  OARegisterViewController.m
//  OneApp
//
//  Created by Dane Hesseldahl on 8/27/12.
//  Copyright (c) 2012 Pierson Labs. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import "OARegisterViewController.h"
#import <QuartzCore/QuartzCore.h>

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation OARegisterViewController

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
    
    [self.signUpView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_sm.png"]]];
    self.signUpView.usernameField.background = [UIImage imageNamed:@"field_bg.png"];
    self.signUpView.passwordField.background = [UIImage imageNamed:@"field_bg.png"];
    self.signUpView.emailField.background = [UIImage imageNamed:@"field_bg.png"];
    self.signUpView.usernameField.textColor = [UIColor blackColor];
    self.signUpView.passwordField.textColor = [UIColor blackColor];
    self.signUpView.emailField.textColor = [UIColor blackColor];
    
    [self.signUpView.signUpButton setBackgroundImage:[UIImage imageNamed:@"btn_register.png"] forState:UIControlStateNormal];
    [self.signUpView.signUpButton setBackgroundImage:[UIImage imageNamed:@"btn_register.png"] forState:UIControlStateHighlighted];
    [self.signUpView.signUpButton setTitle:@"" forState:UIControlStateNormal];
    [self.signUpView.signUpButton setTitle:@"" forState:UIControlStateHighlighted];
    
    //self.signUpView.signUpButton.tintColor = [UIColor clearColor];
    //self.signUpView.signUpButton.backgroundColor = UIColorFromRGB(0xf2965d);
    //self.signUpView.signUpButton.titleLabel.textColor = [UIColor whiteColor];
    //[self.signUpView.signUpButton.layer setBorderWidth: 0.0];
}

////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLayoutSubviews 
{
    // Set frame for elements
    //[self.logInView.dismissButton setFrame:CGRectMake(10.0f, 10.0f, 87.5f, 45.5f)];
    [self.signUpView.logo setFrame:CGRectMake(110, 45, 100, 100)];
    [self.signUpView.usernameField setFrame:CGRectMake(25, 160, 270, 30)];
    [self.signUpView.passwordField setFrame:CGRectMake(25, 195, 270, 30)];
    [self.signUpView.emailField setFrame:CGRectMake(25, 230, 270, 30)];
    [self.signUpView.signUpButton setFrame:CGRectMake(35, 300, 250, 30)];
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
