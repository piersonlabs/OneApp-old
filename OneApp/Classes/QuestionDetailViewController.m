////////////////////////////////////////////////////////////////////////////////
//
//  QuestionDetailViewController.m
//  OneApp
//
//  Created by Dane Hesseldahl on 8/9/12.
//  Copyright (c) 2012 Pierson Labs. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import <QuartzCore/QuartzCore.h>
#import "QuestionDetailViewController.h"
#import "ResultDetailViewController.h"
#import "QuestionDetailViewController.h"
#import "ResponseListViewController.h"
#import "ResultQuiltViewController.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation QuestionDetailViewController

////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) 
    {
        self.title = @"Explore";
        
        [self tableView].backgroundColor = [UIColor whiteColor];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];

    }
    
    return self;
}

////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trees3.png"]];
    [tempImageView setFrame:self.tableView.frame]; 
    
    self.tableView.backgroundView = tempImageView;
    [tempImageView release];
    
    UIView *footer = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 45)] autorelease];
    footer.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footer;
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
    return 5;
}

////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) 
    {
        case 0:
            return 3;
            break;
            
        case 1:
            return 1;
            break;
            
        case 2:
            return 1;
            break;
            
        case 3:
            return 1;
            break;
            
        case 4:
            return 1;
            break;
            
        default:
            return 1;
            break;
    }
    
}

////////////////////////////////////////////////////////////////////////////////
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    switch (section) 
    {
        case 0:
            return @"Post Question";
            break;
            
        case 1:
            return @"Friends";
            break;
            
        case 2:
            return @"Social Graph";
            break;
            
        case 3:
            return @"The World";
            break;
            
        case 4:
            return @"Question Settings";
            break;
            
        default:
            return @"";
            break;
    }
    
    return @"";
}

////////////////////////////////////////////////////////////////////////////////
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *container = [[[UIView alloc] initWithFrame:CGRectMake(0,0,320,20)] autorelease];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    [title setLineBreakMode:UILineBreakModeWordWrap];
    [title setMinimumFontSize:10];
    [title setNumberOfLines:0];
    [title setBackgroundColor:colorFromRGBA(55, 192, 117, 0.7f)];
    [title setFont:[UIFont fontWithName:@"Futura-Medium" size:10]];
    [title setFrame:CGRectMake(10, 12, 300, 20)];
    
    title.text = [NSString stringWithFormat:@"  %@", [self tableView:tableView titleForHeaderInSection:section]];
    [container addSubview:title];
    
    return container;
}

////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7f];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.contentView.layer.cornerRadius = 0;
    cell.contentView.layer.masksToBounds = YES;

    //cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"Didot" size:18];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.frame = CGRectMake(0, 25, 320, 100);
    cell.textLabel.numberOfLines = 0;
    cell.layer.shadowOpacity = 0.0;

    
    switch (indexPath.section) 
    {
        case 0:
        {
            switch (indexPath.row) 
            {
                case 0:
                    cell.textLabel.text = @"Post to Facebook";
                    break;
                    
                case 1:
                    cell.textLabel.text = @"Post to Twitter";
                    break;
                    
                case 2:
                    cell.textLabel.text = @"Pin to Pinterest";
                    break;
            }
        }
        break;
            
        case 1:
            cell.textLabel.text = @"See Results";
            break;
            
        case 2:
            cell.textLabel.text = @"See Results";
            break;
            
        case 3:
            cell.textLabel.text = @"See Visualization";
            break;
            
        case 4:
            cell.textLabel.text = @"Change Settings";
            break;
            
        default:
            cell.textLabel.text = @"";
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) 
    {
        case 0:
        {
        }
            break;
            
        case 1:
        {
            ResultDetailViewController *detailViewController = [[ResultDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController release];
        }
            break;
            
        case 2:
        {
            ResultDetailViewController *detailViewController = [[ResultDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController release];
        }
            break;
            
        case 3:
        {
            ResultQuiltViewController *detailViewController = [[ResultQuiltViewController alloc] init];
            [self.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController release];
        }
            break;
            
        case 4:
            break;
            
        default:
        {
            ResultDetailViewController *detailViewController = [[ResultDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController release];
        }
            break;
    }
}

@end
