////////////////////////////////////////////////////////////////////////////////
//
//  ResultDetailViewController.m
//  OneApp
//
//  Created by Dane Hesseldahl on 8/9/12.
//  Copyright (c) 2012 Pierson Labs. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import <QuartzCore/QuartzCore.h>
#import "ResultDetailViewController.h"
#import "QuestionDetailViewController.h"
#import "ResponseListViewController.h"
#import "ResultQuiltViewController.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation ResultDetailViewController

////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) 
    {
        self.title = @"Result Detail";
        
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
    return 3;
}

////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) 
    {
        case 0:
            return 1;
            break;
            
        case 1:
            return 4;
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
            return @"Question Details";
            break;
            
        case 1:
            return @"Responses";
            break;
            
        case 2:
            return @"Visualizations";
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
            cell.textLabel.text = @"View Question";
            break;
            
        case 1:
        {
            switch (indexPath.row) 
            {
                case 0:
                    cell.textLabel.text = @"View All Responses";
                    break;
                    
                case 1:
                    cell.textLabel.text = @"View Facebook Comments";
                    break;
                    
                case 2:
                    cell.textLabel.text = @"View Twitter Replies";
                    break;
                    
                case 3:
                    cell.textLabel.text = @"View Pinterest Pins";
                    break;
            }
        }
            break;
            
        case 2:
            cell.textLabel.text = @"See Visualization";
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
            QuestionDetailViewController *detailViewController = [[QuestionDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController release];
        }
        break;
            
        case 1:
        {
            ResponseListViewController *detailViewController = [[ResponseListViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController release];
        }
        break;
            
        case 2:
        {
            ResultQuiltViewController *detailViewController = [[ResultQuiltViewController alloc] init];
            [self.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController release];
        }
        break;
            
        default:
        {
            ResponseListViewController *detailViewController = [[ResponseListViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController release];
        }
        break;
    }
}


@end
