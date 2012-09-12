////////////////////////////////////////////////////////////////////////////////
//
//  ResultsTableViewController.m
//  OneApp
//
//  Created by Dane Hesseldahl on 8/8/12.
//  Copyright (c) 2012 Pierson Labs. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import "ResultsTableViewController.h"
#import "ResultDetailViewController.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation ResultsTableViewController

////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) 
    {
        self.title = @"Answers";
        [self tableView].backgroundColor = [UIColor blackColor];
        [self tableView].separatorColor = [UIColor blackColor];
        [self tableView].separatorStyle =  UITableViewCellSeparatorStyleNone;
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
    if ((indexPath.row % 2) != 0)
    {
        return 44;
    }
    else
    {
        return 145;
    }
}


////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
    if ((indexPath.row % 2) == 0)
    {
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"Didot" size:18];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.frame = CGRectMake(0, 25, 320, 100);
        cell.textLabel.numberOfLines = 0;
        
        UIButton *btn_view = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_view.frame = CGRectMake(290, 118, 20, 20);
        [btn_view setImage:[UIImage imageNamed:@"view.png"] forState:UIControlStateNormal];
        [btn_view addTarget:self action:@selector(viewClick:) forControlEvents:UIControlEventTouchUpInside];
        //objc_setAssociatedObject(btn_replace, @"FPRecipeID", recipe.id, OBJC_ASSOCIATION_RETAIN);
        [btn_view setTag:6];
        [cell addSubview:btn_view];
    }
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    [title setLineBreakMode:UILineBreakModeWordWrap];
    [title setMinimumFontSize:10];
    [title setNumberOfLines:0];
    [title setBackgroundColor:colorFromRGBA(55, 192, 117, 0.7f)];
    [title setFont:[UIFont fontWithName:@"Futura-Medium" size:8]];
    [title setTag:1];
    [title setHidden:YES];
    [cell addSubview:title];
    [title setFrame:CGRectMake(10, 12, 300, 16)];
    
    UILabel *details = [[UILabel alloc] initWithFrame:CGRectZero];
    [details setLineBreakMode:UILineBreakModeWordWrap];
    [details setMinimumFontSize:10];
    [details setNumberOfLines:0];
    [details setTextColor:[UIColor whiteColor]];
    [details setBackgroundColor:colorFromRGBA(0, 0, 0, 0.6f)];
    [details setFont:[UIFont fontWithName:@"GillSans" size:8]];
    [details setTag:1];
    [details setHidden:YES];
    [cell addSubview:details];
    [details setFrame:CGRectMake(10, 121, 270, 16)];
    
    if ((indexPath.row % 2) != 0)
    {
        [title setHidden:YES];
        UIImage * orgImage = [UIImage imageNamed:@"sep.png"];
        [cell.contentView addSubview:[[UIImageView alloc] initWithImage:orgImage]];
    }
    else 
    {
        UIImage * orgImage = [UIImage imageNamed:@"one.jpg"];
        //UIImage * orgImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];
        UIImage* resizeImage = [orgImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(320, 145) interpolationQuality:kCGInterpolationHigh];
        UIImage *result = [resizeImage croppedImage:CGRectMake(0, 0, 320, 145)];
        [cell.contentView insertSubview:[[UIImageView alloc] initWithImage:result] belowSubview:cell.textLabel];
        
        [title setHidden:NO];
        [title setText:@" 08.27.2012"];
        
        [details setHidden:NO];
        [details setText:@"  (2) Facebook (18) Twitter (7) Pinterest"];
        
        cell.textLabel.text = @"\"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla auctor faucibus gravida.\"";
    }
    
    return cell;
}

////////////////////////////////////////////////////////////////////////////////
- (void) viewClick:(id)sender
{
    //NSNumber* recipeID = (NSNumber*)objc_getAssociatedObject(sender, @"FPRecipeID");
    
    ResultDetailViewController *detailViewController = [[ResultDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

#pragma mark - Table view delegate

////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResultDetailViewController *detailViewController = [[ResultDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

@end
