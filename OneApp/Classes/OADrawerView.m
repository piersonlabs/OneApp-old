////////////////////////////////////////////////////////////////////////////////
//
//  OADrawerView.m
//  FivePlates
//
//  Created by Dane Hesseldahl on 8/1/12.
//  Copyright (c) 2012 Pierson Labs. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import "OADrawerView.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation OADrawerView

////////////////////////////////////////////////////////////////////////////////
@synthesize delegate;
@synthesize btnHandle = _btnHandle;
@synthesize open = _open;

////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        _open = NO;
		
		UIImageView *drawer_bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drawer.png"]];
		drawer_bg.frame = CGRectMake(0, 0, 320, 170);
		[self addSubview:drawer_bg];
		
		[self setBtnHandle: [UIButton buttonWithType:UIButtonTypeCustom]];
		[self btnHandle].frame = CGRectMake(0, 0, 320, 37);
		[[self btnHandle] setImage:[UIImage imageNamed:@"handle.png"] forState:UIControlStateNormal];
		[[self btnHandle] addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:[self btnHandle]];
        
        UIButton *btn_questions = [UIButton buttonWithType:UIButtonTypeCustom];
		btn_questions.frame = CGRectMake(0, 38, 155, 63);
		[btn_questions setImage:[UIImage imageNamed:@"drawer_right.png"] forState:UIControlStateNormal];
		[btn_questions addTarget:self action:@selector(questionsClick:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:btn_questions];
        
        UITextField *questionsTitle = [[UITextField alloc] initWithFrame:CGRectMake(00, 23, 155, 50)];
        questionsTitle.userInteractionEnabled = NO;
		questionsTitle.font = [UIFont fontWithName:@"GillSans-Light" size:18];
		questionsTitle.textColor = [UIColor whiteColor];
        questionsTitle.textAlignment = UITextAlignmentCenter;
		questionsTitle.text = @"Explore";
        [btn_questions addSubview:questionsTitle];
        
        UIButton *btn_results = [UIButton buttonWithType:UIButtonTypeCustom];
		btn_results.frame = CGRectMake(0, 103, 155, 63);
		[btn_results setImage:[UIImage imageNamed:@"drawer_right.png"] forState:UIControlStateNormal];
		[btn_results addTarget:self action:@selector(askClick:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:btn_results];
        
        UITextField *resultsTitle = [[UITextField alloc] initWithFrame:CGRectMake(00, 23, 155, 50)];
        resultsTitle.userInteractionEnabled = NO;
		resultsTitle.font = [UIFont fontWithName:@"GillSans-Light" size:18];
		resultsTitle.textColor = [UIColor whiteColor];
        resultsTitle.textAlignment = UITextAlignmentCenter;
		resultsTitle.text = @"Ask";
        [btn_results addSubview:resultsTitle];
        
        UIButton *btn_favorites = [UIButton buttonWithType:UIButtonTypeCustom];
		btn_favorites.frame = CGRectMake(165, 38, 155, 63);
		[btn_favorites setImage:[UIImage imageNamed:@"drawer_left.png"] forState:UIControlStateNormal];
		[btn_favorites addTarget:self action:@selector(settingsClick:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:btn_favorites];
        
        UITextField *favoritesTitle = [[UITextField alloc] initWithFrame:CGRectMake(00, 23, 155, 50)];
        favoritesTitle.userInteractionEnabled = NO;
		favoritesTitle.font = [UIFont fontWithName:@"GillSans-Light" size:18];
		favoritesTitle.textColor = [UIColor whiteColor];
        favoritesTitle.textAlignment = UITextAlignmentCenter;
		favoritesTitle.text = @"Friends";
        [btn_favorites addSubview:favoritesTitle];
        
        UIButton *btn_settings = [UIButton buttonWithType:UIButtonTypeCustom];
		btn_settings.frame = CGRectMake(165, 103, 155, 63);
		[btn_settings setImage:[UIImage imageNamed:@"drawer_left.png"] forState:UIControlStateNormal];
		[btn_settings addTarget:self action:@selector(resultsClick:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:btn_settings];
        
        UITextField *settingsTitle = [[UITextField alloc] initWithFrame:CGRectMake(00, 23, 155, 50)];
        settingsTitle.userInteractionEnabled = NO;
		settingsTitle.font = [UIFont fontWithName:@"GillSans-Light" size:18];
		settingsTitle.textColor = [UIColor whiteColor];
        settingsTitle.textAlignment = UITextAlignmentCenter;
		settingsTitle.text = @"Logout";
        [btn_settings addSubview:settingsTitle];
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////
- (void) questionsClick:(id)sender
{
	_open = NO;
	[(id)[self delegate] performSelectorOnMainThread:@selector(showQuestions) withObject:nil waitUntilDone:YES];
}

////////////////////////////////////////////////////////////////////////////////
- (void) resultsClick:(id)sender
{
	_open = NO;
	[(id)[self delegate] performSelectorOnMainThread:@selector(showResults) withObject:nil waitUntilDone:YES];
}

////////////////////////////////////////////////////////////////////////////////
- (void) settingsClick:(id)sender
{
	_open = NO;
	[(id)[self delegate] performSelectorOnMainThread:@selector(showSettings) withObject:nil waitUntilDone:YES];
}

////////////////////////////////////////////////////////////////////////////////
- (void) askClick:(id)sender
{
	_open = NO;
	[(id)[self delegate] performSelectorOnMainThread:@selector(showAsk) withObject:nil waitUntilDone:YES];
}

////////////////////////////////////////////////////////////////////////////////
- (void) handleClick:(id)sender
{
	if(_open)
	{
		_open = NO;
		[(id)[self delegate] performSelectorOnMainThread:@selector(hideDrawer) withObject:nil waitUntilDone:YES];
	}
	else 
	{
		_open = YES;
		[(id)[self delegate] performSelectorOnMainThread:@selector(showDrawer) withObject:nil waitUntilDone:YES];
	}
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
