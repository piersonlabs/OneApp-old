////////////////////////////////////////////////////////////////////////////////
//
//  OALoginView.m
//  OneApp
//
//  Created by Dane Hesseldahl on 8/8/12.
//  Copyright (c) 2012 Pierson Labs. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import "OALoginView.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation OALoginView

@synthesize user = _user;
@synthesize pass = _pass;

////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        //add the bg
		UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
		bg.frame = CGRectMake(0, 0, APP_FULL_WIDTH, APP_FULL_HEIGHT);
		[self addSubview:bg];
		[bg release];
        
        //add the logo
		UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
		logo.frame = CGRectMake(123, 50, 67, 152);
		[self addSubview:logo];
		[logo release];
        
        UIImageView *field_bg1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"field_bg.png"]];
		field_bg1.frame = CGRectMake(25, 225, 270, 30);
		[self addSubview:field_bg1];
		[field_bg1 release];
		
		UIImageView *field_bg2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"field_bg.png"]];
		field_bg2.frame = CGRectMake(25, 280, 270, 30);
		[self addSubview:field_bg2];
		[field_bg2 release];
        
        UIButton *btn_signin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		btn_signin.frame = CGRectMake(85, 400, 150, 40);
        [btn_signin setTitle:@"Login" forState:UIControlStateNormal];
        //[btn_signin setImage:[UIImage imageNamed:@"signin.png"] forState:UIControlStateNormal];
		[btn_signin addTarget:self action:@selector(signinClick:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:btn_signin];
        
        [self setUser:[[UITextField alloc] initWithFrame:CGRectMake(55, 232, 230, 20)]];
		[self user].delegate = self;
		[self user].autocapitalizationType = UITextFieldViewModeNever;
		[self user].autocorrectionType = UITextAutocorrectionTypeNo;
		[self user].userInteractionEnabled = YES;
		[self user].backgroundColor = [UIColor clearColor];
		[self user].font = [UIFont systemFontOfSize:14];
		//[self user].textColor = UIColorFromRGB(0x000000);
		[self user].clearsOnBeginEditing = YES;
		[self user].placeholder = @"username";
		[[self user] setReturnKeyType:UIReturnKeyDone];
		[self addSubview:[self user]];
		
		[self setPass:[[UITextField alloc] initWithFrame:CGRectMake(55, 287, 230, 20)]];
		[self pass].delegate = self;
		[self pass].autocapitalizationType = UITextFieldViewModeNever;
		[self pass].autocorrectionType = UITextAutocorrectionTypeNo;
		[self pass].userInteractionEnabled = YES;
		[self pass].backgroundColor = [UIColor clearColor];
		[[self pass] setReturnKeyType:UIReturnKeyDone];
		[self pass].font = [UIFont systemFontOfSize:14];
		//[self pass].textColor = UIColorFromRGB(0x000000);
		[self pass].clearsOnBeginEditing = YES;
		[self pass].placeholder = @"password";
		[self addSubview:[self pass]];
		
		[[self user] becomeFirstResponder];
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    [_user release];
    [_pass release];
    [super dealloc];
}

////////////////////////////////////////////////////////////////////////////////
- (void) signinClick:(id)sender
{
    [self showLoader];
    [(id)[self delegate] performSelectorOnMainThread:@selector(doLogin) withObject:nil waitUntilDone:YES];
}

////////////////////////////////////////////////////////////////////////////////
- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
	[[self user] resignFirstResponder];
	[[self pass] resignFirstResponder];
	return YES;
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
