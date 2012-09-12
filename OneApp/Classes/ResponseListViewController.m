////////////////////////////////////////////////////////////////////////////////
//
//  ResponseListViewController.m
//  OneApp
//
//  Created by Dane Hesseldahl on 8/9/12.
//  Copyright (c) 2012 Pierson Labs. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import <QuartzCore/QuartzCore.h>
#import "ResponseListViewController.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation ResponseListViewController

////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) 
    {
        self.title = @"Responses";
        
        [self tableView].backgroundColor = [UIColor whiteColor];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    }
    
    return self;
}

////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *footer = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 35)] autorelease];
    footer.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footer;
    [footer release];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trees3.png"]];
    [tempImageView setFrame:self.tableView.frame]; 
    
    self.tableView.backgroundView = tempImageView;
    [tempImageView release];
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

#pragma mark - Table view data source

////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 100;
}

////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8f];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.contentView.layer.cornerRadius = 0;
    cell.contentView.layer.masksToBounds = YES;
    
    UILabel *details = [[UILabel alloc] initWithFrame:CGRectZero];
    [details setLineBreakMode:UILineBreakModeWordWrap];
    [details setMinimumFontSize:10];
    [details setNumberOfLines:0];
    [details setTextColor:[UIColor whiteColor]];
    [details setBackgroundColor:[UIColor clearColor]];
    [details setFont:[UIFont fontWithName:@"Didot" size:18]];
    [cell addSubview:details];
    [details setFrame:CGRectMake(65, 5, 245, 75)];
    details.text = @"Neque porro quisquam est qui dolorem ipsum quia dolor sit amet";
    details.numberOfLines = 0;
    
    UILabel *user = [[UILabel alloc] initWithFrame:CGRectZero];
    [user setLineBreakMode:UILineBreakModeWordWrap];
    [user setMinimumFontSize:10];
    [user setNumberOfLines:0];
    [user setTextColor:[UIColor whiteColor]];
    [user setBackgroundColor:[UIColor clearColor]];
    [user setFont:[UIFont fontWithName:@"Futura-Medium" size:12]];
    [user setTextAlignment:UITextAlignmentRight];
    [cell addSubview:user];
    [user setFrame:CGRectMake(200, 75, 100, 30)];
    user.text = @"  - @fangs";
    user.numberOfLines = 0;
    
    UIImageView* avatar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar.png"]];
    [avatar setFrame:CGRectMake(5, 10, 50, 50)];
    [cell.contentView addSubview:avatar];
    [avatar release];
    
    return cell;
}

#pragma mark - Table view delegate

////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
