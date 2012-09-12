////////////////////////////////////////////////////////////////////////////////
//
//  OABaseViewController.h
//  OneApp
//
//  Created by Dane Hesseldahl on 8/8/12.
//  Copyright (c) 2012 Pierson Labs. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import <UIKit/UIKit.h>
#import "OABaseView.h"
#import "OALoginViewController.h"
#import "QuestionsTableViewController.h"
#import "ResultsTableViewController.h"
#import "SettingsViewController.h"
#import "OADrawerView.h"
#import "OAAskViewController.h"
#import "OAFindFriendsViewController.h"

////////////////////////////////////////////////////////////////////////////////
#define APP_FULL_WIDTH 320
#define APP_FULL_HEIGHT	480

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@interface OABaseViewController : UIViewController <OADrawerViewDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, PF_FBRequestDelegate>
{
    NSString *_state;
	NSString *_stateNext;
    
    //OADrawerView* _drawer;
    OALoginViewController* _loginView;
    UINavigationController* _navigationController;
    QuestionsTableViewController * _questionView;
    ResultsTableViewController *_resultsView;
    SettingsViewController* _settingsView;
    OAAskViewController* _askView;
	OAFindFriendsViewController* _findFriendsView;
	NSTimer *_autoFollowTimer;
	
	UIView *_loader;
	UIActivityIndicatorView *_activityIndicator;
	
	NSMutableData *_data;
    BOOL firstLaunch;
}

//////////////////////////////////////////////////////////////////////////////
@property (nonatomic, retain) UINavigationController* navigationController;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *stateNext;
@property (nonatomic, retain) OALoginViewController* loginView;
@property (nonatomic, retain) QuestionsTableViewController * questionView;
@property (nonatomic, retain) OADrawerView* drawer;
@property (nonatomic, retain) ResultsTableViewController *resultsView;
@property (nonatomic, retain) SettingsViewController* settingsView;
@property (nonatomic, retain) OAAskViewController* askView;
@property (nonatomic, retain) OAFindFriendsViewController* findFriendsView;
@property (nonatomic, strong) NSTimer *autoFollowTimer;
@property (nonatomic, retain) UIView *loader;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

//////////////////////////////////////////////////////////////////////////////
-(void)showLogin;
- (void) logout;
- (void)showDrawer;
- (void)hideDrawer;
- (void)showHandle;
- (void)hidehandle;
-(void)showNavigationBar;
-(void)hideNavigationBar;
-(void)showAsk;
- (void) showLoader;
- (void) hideLoader;

-(void)showQuestions;
-(void)showQuestionAfterAsk;
-(void)showResults;
-(void)showSettings;

@end
