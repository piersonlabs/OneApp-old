////////////////////////////////////////////////////////////////////////////////
//
//  QuestionsTableViewController.m
//  OneApp
//
//  Created by Dane Hesseldahl on 8/8/12.
//  Copyright (c) 2012 Pierson Labs. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import <QuartzCore/QuartzCore.h>
#import "QuestionsTableViewController.h"
#import "QuestionDetailViewController.h"
#import "VariableHeightCell.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation QuestionsTableViewController

////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) 
    {
        self.title = @"Ask Questions";
        [self tableView].backgroundColor = [UIColor blackColor];
        [self tableView].separatorColor = [UIColor blackColor];
        [self tableView].separatorStyle =  UITableViewCellSeparatorStyleNone;
		
		// The className to query on
        self.className = kOAQuestionClassKey;
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
        
        // Improve scrolling performance by reusing UITableView section headers
        //self.reusableSectionHeaderViews = [NSMutableSet setWithCapacity:3];
        self.shouldReloadOnAppear = YES;
		
		[self setSystemQuestions:[[NSArray alloc] init]];
		[self setUserQuestions:[[NSArray alloc] init]];
		[self setFriendQuestions:[[NSArray alloc] init]];

    }
    
    return self;
}

////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *footer = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 35)] autorelease];
    footer.backgroundColor = [UIColor blackColor];
    self.tableView.tableFooterView = footer;
    [footer release];
}

////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload
{
    [super viewDidUnload];
}

////////////////////////////////////////////////////////////////////////////////
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.shouldReloadOnAppear)
	{
        self.shouldReloadOnAppear = NO;
        [self loadObjects];
    }
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
	//NSInteger sections = self.objects.count;
	//    if (self.paginationEnabled && sections != 0)
	//        sections++;
	//return sections;
	
	switch (section)
	{
		case 0:
			return [self.systemQuestions count];
			break;
			
		case 1:
			return [self.userQuestions count];
			break;
			
		case 2:
			return [self.friendQuestions count];
			break;
			
		default:
			return [self.objects count];
			break;
	}
}

////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 189;
}

////////////////////////////////////////////////////////////////////////////////
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return ([self.systemQuestions count] > 0 ) ? @"System Questions" : @"";
            break;
            
        case 1:
            return ([self.userQuestions count] > 0 ) ? @"My Questions" : @"";
            break;
            
        case 2:
            return ([self.friendQuestions count] > 0 ) ? @"Questions from my Friends" : @"";
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
    UIView *container = [[[UIView alloc] initWithFrame:CGRectMake(0,0,320,30)] autorelease];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    [title setLineBreakMode:UILineBreakModeWordWrap];
    [title setMinimumFontSize:10];
    [title setNumberOfLines:0];
    [title setTextColor:[UIColor whiteColor]];
    [title setBackgroundColor:[UIColor blackColor]];
    [title setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15]];
    [title setFrame:CGRectMake(0, 0, 320, 30)];
    
    title.text = [NSString stringWithFormat:@"  %@", [self tableView:tableView titleForHeaderInSection:section]];
    [container addSubview:title];
    
    return container;
}

////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *CellIdentifier = @"Cell";
    UILabel *title = nil;
    //UILabel *label = nil;
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];

	cell.textLabel.backgroundColor = [UIColor clearColor];
	cell.textLabel.font = [UIFont fontWithName:@"Didot" size:18];
	cell.textLabel.textColor = [UIColor whiteColor];
	cell.textLabel.frame = CGRectMake(0, 25, 320, 100);
	cell.textLabel.numberOfLines = 0;
	
	UIButton *btn_facebook = [UIButton buttonWithType:UIButtonTypeCustom];
	btn_facebook.frame = CGRectMake(155, 118, 20, 20);
	[btn_facebook setImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateNormal];
	//[btn_replace addTarget:self action:@selector(viewClick:) forControlEvents:UIControlEventTouchUpInside];
	//objc_setAssociatedObject(btn_replace, @"FPRecipeID", recipe.id, OBJC_ASSOCIATION_RETAIN);
	[btn_facebook setTag:4];
	[cell addSubview:btn_facebook];
	
	UIButton *btn_twitter = [UIButton buttonWithType:UIButtonTypeCustom];
	btn_twitter.frame = CGRectMake(200, 118, 20, 20);
	[btn_twitter setImage:[UIImage imageNamed:@"twitter.png"] forState:UIControlStateNormal];
	//[btn_replace addTarget:self action:@selector(viewClick:) forControlEvents:UIControlEventTouchUpInside];
	//objc_setAssociatedObject(btn_replace, @"FPRecipeID", recipe.id, OBJC_ASSOCIATION_RETAIN);
	[btn_twitter setTag:5];
	[cell addSubview:btn_twitter];
	
	UIButton *btn_pinterest = [UIButton buttonWithType:UIButtonTypeCustom];
	btn_pinterest.frame = CGRectMake(245, 118, 20, 20);
	[btn_pinterest setImage:[UIImage imageNamed:@"pinterest.png"] forState:UIControlStateNormal];
	//[btn_replace addTarget:self action:@selector(viewClick:) forControlEvents:UIControlEventTouchUpInside];
	//objc_setAssociatedObject(btn_replace, @"FPRecipeID", recipe.id, OBJC_ASSOCIATION_RETAIN);
	[btn_pinterest setTag:6];
	[cell addSubview:btn_pinterest];
	
	UIButton *btn_view = [UIButton buttonWithType:UIButtonTypeCustom];
	btn_view.frame = CGRectMake(290, 118, 20, 20);
	[btn_view setImage:[UIImage imageNamed:@"view.png"] forState:UIControlStateNormal];
	[btn_view addTarget:self action:@selector(viewClick:) forControlEvents:UIControlEventTouchUpInside];
	//objc_setAssociatedObject(btn_replace, @"FPRecipeID", recipe.id, OBJC_ASSOCIATION_RETAIN);
	[btn_view setTag:6];
	[cell addSubview:btn_view];
    
    title = [[UILabel alloc] initWithFrame:CGRectZero];
    [title setLineBreakMode:UILineBreakModeWordWrap];
    [title setMinimumFontSize:10];
    [title setNumberOfLines:0];
    [title setBackgroundColor:colorFromRGBA(55, 192, 117, 0.7f)];
    [title setFont:[UIFont fontWithName:@"Futura-Medium" size:8]];
    [title setTag:1];
    [cell addSubview:title];
    [title setFrame:CGRectMake(10, 12, 300, 16)];

   UIImage * orgImage = [UIImage imageNamed:@"one.jpg"];
	//UIImage * orgImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];
	UIImage* resizeImage = [orgImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(320, 145) interpolationQuality:kCGInterpolationHigh];
	UIImage *result = [resizeImage croppedImage:CGRectMake(0, 0, 320, 145)];
	[cell.contentView insertSubview:[[UIImageView alloc] initWithImage:result] belowSubview:cell.textLabel];

	[title setHidden:NO];
	[title setText:@" 08.27.2012"];
        
	cell.textLabel.text = [object objectForKey:kOAQuestionTextKey];
    
	UIImageView * sepImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sep.png"]];
	sepImage.frame = CGRectMake(0, 145, 320, 44);
	[cell.contentView addSubview:sepImage];
	
    return cell;
}

////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *LoadMoreCellIdentifier = @"LoadMoreCell";
    
    //PAPLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
    //if (!cell)
	//{
    //    cell = [[PAPLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreCellIdentifier];
    //    cell.selectionStyle =UITableViewCellSelectionStyleGray;
    //    cell.separatorImageTop.image = [UIImage imageNamed:@"SeparatorTimelineDark.png"];
    //    cell.hideSeparatorBottom = YES;
    //    cell.mainView.backgroundColor = [UIColor clearColor];
    //}
    //return cell;
	return nil;
}

#pragma mark - PFQueryTableViewController

////////////////////////////////////////////////////////////////////////////////
- (PFQuery *)queryForTable
{
	self.className = kOAQuestionClassKey;
	
    if (![PFUser currentUser])
	{
        PFQuery *query = [PFQuery queryWithClassName:self.className];
        [query setLimit:0];
        return query;
    }
    
    PFQuery *followingActivitiesQuery = [PFQuery queryWithClassName:kOAActivityClassKey];
    [followingActivitiesQuery whereKey:kOAActivityTypeKey equalTo:kOAActivityTypeFollow];
    [followingActivitiesQuery whereKey:kOAActivityFromUserKey equalTo:[PFUser currentUser]];
    followingActivitiesQuery.limit = 1000;
    
    PFQuery *photosFromFollowedUsersQuery = [PFQuery queryWithClassName:self.className];
    [photosFromFollowedUsersQuery whereKey:kOAQuestionUserKey matchesKey:kOAActivityToUserKey inQuery:followingActivitiesQuery];
    //[photosFromFollowedUsersQuery whereKeyExists:kOAQuestionPictureKey];
	
    //PFQuery *photosFromCurrentUserQuery = [PFQuery queryWithClassName:self.className];
    //[photosFromCurrentUserQuery whereKey:kPAPPhotoUserKey equalTo:[PFUser currentUser]];
    //[photosFromCurrentUserQuery whereKeyExists:kPAPPhotoPictureKey];
	
    //PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:photosFromFollowedUsersQuery, photosFromCurrentUserQuery, nil]];
    //[query includeKey:kPAPPhotoUserKey];
    //[query orderByDescending:@"createdAt"];
	
	PFQuery *userquery = [PFQuery queryWithClassName:self.className];
    [userquery whereKey:kOAQuestionUserKey equalTo:[PFUser currentUser]];
	[userquery whereKey:kOAQuestionTypeKey equalTo:@"user"];
	
    //[userquery orderByDescending:@"createdAt"];
	
	PFQuery *systemquery = [PFQuery queryWithClassName:self.className];
    //[systemquery whereKey:kOAQuestionUserKey equalTo:0];
	[systemquery whereKey:kOAQuestionTypeKey equalTo:@"system"];
    //[systemquery orderByDescending:@"createdAt"];
	
	PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:userquery, systemquery, photosFromFollowedUsersQuery, nil]];
    [query includeKey:kOAQuestionUserKey];
    [query orderByDescending:@"createdAt"];
	
	[self setSystemQuestions:[systemquery findObjects]];
	[self setUserQuestions:[userquery findObjects]];
	[self setFriendQuestions:[photosFromFollowedUsersQuery findObjects]];
	
    // A pull-to-refresh should always trigger a network request.
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
	
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    //
    // If there is no network connection, we will hit the cache first.
    if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)])
	{
        [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    }
    
    return query;
}

////////////////////////////////////////////////////////////////////////////////
- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.section)
	{
		case 0:
			return [self.systemQuestions objectAtIndex:indexPath.row];
			break;
			
		case 1:
			return [self.userQuestions objectAtIndex:indexPath.row];
			break;
			
		case 2:
			return [self.friendQuestions objectAtIndex:indexPath.row];
			break;
			
		default:
			return [self.objects objectAtIndex:indexPath.row];
			break;
	}

}

////////////////////////////////////////////////////////////////////////////////
- (void) viewClick:(id)sender
{
    //NSNumber* recipeID = (NSNumber*)objc_getAssociatedObject(sender, @"FPRecipeID");
    
    QuestionDetailViewController *detailViewController = [[QuestionDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

#pragma mark - Table view delegate

////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //QuestionDetailViewController *detailViewController = [[QuestionDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    //[self.navigationController pushViewController:detailViewController animated:YES];
    //[detailViewController release];
}

@end
