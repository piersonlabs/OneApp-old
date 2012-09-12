////////////////////////////////////////////////////////////////////////////////
//
//  SettingsViewController.m
//  OneApp
//
//  Created by Dane Hesseldahl on 8/9/12.
//  Copyright (c) 2012 Pierson Labs. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import "SettingsViewController.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation SettingsViewController

////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) 
    {
        self.title = @"Settings";
        
        UIView *footer = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 45)] autorelease];
        footer.backgroundColor = [UIColor clearColor];
        self.tableView.tableFooterView = footer;
    }
    
    return self;
}

////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
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

#pragma mark - Table view data source

////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

////////////////////////////////////////////////////////////////////////////////
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    switch (section) 
    {
        case 0:
            return @"My Account";
            break;
            
        case 1:
            return @"Social Networks";
            break;
            
        case 2:
            return @"Privacy Options";
            break;
            
        default:
            return @"";
            break;
    }
    
    return @"";
}


////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Setting %d", indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


@end
