//
//  OAUtility.m
//  OneApp
//
//  Created by Dane Hesseldahl on 9/11/12.
//  Copyright (c) 2012 Pierson Labs. All rights reserved.
//

#import "OAUtility.h"
#import "UIImage+ResizeAdditions.h"

@implementation OAUtility


#pragma mark - OAUtility
#pragma mark Like Photos

+ (void)likePhotoInBackground:(id)photo block:(void (^)(BOOL succeeded, NSError *error))completionBlock
{
    PFQuery *queryExistingLikes = [PFQuery queryWithClassName:kOAActivityClassKey];
    [queryExistingLikes whereKey:kOAActivityQuestionKey equalTo:photo];
    [queryExistingLikes whereKey:kOAActivityTypeKey equalTo:kOAActivityTypeLike];
    [queryExistingLikes whereKey:kOAActivityFromUserKey equalTo:[PFUser currentUser]];
    [queryExistingLikes setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error)
	{
        if (!error)
		{
            for (PFObject *activity in activities)
			{
                [activity delete];
            }
        }
        
        // proceed to creating new like
        PFObject *likeActivity = [PFObject objectWithClassName:kOAActivityClassKey];
        [likeActivity setObject:kOAActivityTypeLike forKey:kOAActivityTypeKey];
        [likeActivity setObject:[PFUser currentUser] forKey:kOAActivityFromUserKey];
        [likeActivity setObject:[photo objectForKey:kOAQuestionUserKey] forKey:kOAActivityToUserKey];
        [likeActivity setObject:photo forKey:kOAActivityQuestionKey];
        
        PFACL *likeACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [likeACL setPublicReadAccess:YES];
        likeActivity.ACL = likeACL;
		
        [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
		{
            if (completionBlock)
			{
                completionBlock(succeeded,error);
            }
			
            if (succeeded && ![[[photo objectForKey:kOAQuestionUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                NSString *privateChannelName = [[photo objectForKey:kOAQuestionUserKey] objectForKey:kOAUserPrivateChannelKey];
                if (privateChannelName && privateChannelName.length != 0) {
                    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSString stringWithFormat:@"%@ likes your photo.", [OAUtility firstNameForDisplayName:[[PFUser currentUser] objectForKey:kOAUserDisplayNameKey]]], kAPNSAlertKey,
                                          kOAPushPayloadPayloadTypeActivityKey, kOAPushPayloadPayloadTypeKey,
                                          kOAPushPayloadActivityLikeKey, kOAPushPayloadActivityTypeKey,
                                          [[PFUser currentUser] objectId], kOAPushPayloadFromUserObjectIdKey,
                                          [photo objectId], kOAPushPayloadQuestionObjectIdKey,
                                          nil];
                    PFPush *push = [[PFPush alloc] init];
                    [push setChannel:privateChannelName];
                    [push setData:data];
                    [push sendPushInBackground];
                }
            }
			
            // refresh cache
            PFQuery *query = [OAUtility queryForActivitiesOnPhoto:photo cachePolicy:kPFCachePolicyNetworkOnly];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    
                    NSMutableArray *likers = [NSMutableArray array];
                    NSMutableArray *commenters = [NSMutableArray array];
                    
                    BOOL isLikedByCurrentUser = NO;
                    
                    for (PFObject *activity in objects) {
                        if ([[activity objectForKey:kOAActivityTypeKey] isEqualToString:kOAActivityTypeLike] && [activity objectForKey:kOAActivityFromUserKey]) {
                            [likers addObject:[activity objectForKey:kOAActivityFromUserKey]];
                        } else if ([[activity objectForKey:kOAActivityTypeKey] isEqualToString:kOAActivityTypeComment] && [activity objectForKey:kOAActivityFromUserKey]) {
                            [commenters addObject:[activity objectForKey:kOAActivityFromUserKey]];
                        }
                        
                        if ([[[activity objectForKey:kOAActivityFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                            if ([[activity objectForKey:kOAActivityTypeKey] isEqualToString:kOAActivityTypeLike]) {
                                isLikedByCurrentUser = YES;
                            }
                        }
                    }
                    
                    [[OACache sharedCache] setAttributesForPhoto:photo likers:likers commenters:commenters likedByCurrentUser:isLikedByCurrentUser];
                }
				
                [[NSNotificationCenter defaultCenter] postNotificationName:OAUtilityUserLikedUnlikedQuestionCallbackFinishedNotification object:photo userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:succeeded] forKey:OAQuestionDetailsViewControllerUserLikedUnlikedQuestionNotificationUserInfoLikedKey]];
            }];
			
        }];
    }];
    
    /*
	 // like photo in Facebook if possible
	 NSString *fbOpenGraphID = [photo objectForKey:kOAPhotoOpenGraphIDKey];
	 if (fbOpenGraphID && fbOpenGraphID.length > 0) {
	 NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
	 NSString *objectURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@", fbOpenGraphID];
	 [params setObject:objectURL forKey:@"object"];
	 [[PFFacebookUtils facebook] requestWithGraphPath:@"me/og.likes" andParams:params andHttpMethod:@"POST" andDelegate:nil];
	 }
	 */
}

+ (void)unlikePhotoInBackground:(id)photo block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    PFQuery *queryExistingLikes = [PFQuery queryWithClassName:kOAActivityClassKey];
    [queryExistingLikes whereKey:kOAActivityQuestionKey equalTo:photo];
    [queryExistingLikes whereKey:kOAActivityTypeKey equalTo:kOAActivityTypeLike];
    [queryExistingLikes whereKey:kOAActivityFromUserKey equalTo:[PFUser currentUser]];
    [queryExistingLikes setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error)
	{
        if (!error)
		{
            for (PFObject *activity in activities)
			{
                [activity delete];
            }
            
            if (completionBlock)
			{
                completionBlock(YES,nil);
            }
			
            // refresh cache
            PFQuery *query = [OAUtility queryForActivitiesOnPhoto:photo cachePolicy:kPFCachePolicyNetworkOnly];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
			{
                if (!error)
				{
                    
                    NSMutableArray *likers = [NSMutableArray array];
                    NSMutableArray *commenters = [NSMutableArray array];
                    
                    BOOL isLikedByCurrentUser = NO;
                    
                    for (PFObject *activity in objects)
					{
                        if ([[activity objectForKey:kOAActivityTypeKey] isEqualToString:kOAActivityTypeLike])
						{
                            [likers addObject:[activity objectForKey:kOAActivityFromUserKey]];
                        }
						else if ([[activity objectForKey:kOAActivityTypeKey] isEqualToString:kOAActivityTypeComment])
						{
                            [commenters addObject:[activity objectForKey:kOAActivityFromUserKey]];
                        }
                        
                        if ([[[activity objectForKey:kOAActivityFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]])
						{
                            if ([[activity objectForKey:kOAActivityTypeKey] isEqualToString:kOAActivityTypeLike])
							{
                                isLikedByCurrentUser = YES;
                            }
                        }
                    }
                    
                    [[OACache sharedCache] setAttributesForPhoto:photo likers:likers commenters:commenters likedByCurrentUser:isLikedByCurrentUser];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:OAUtilityUserLikedUnlikedQuestionCallbackFinishedNotification object:photo userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:OAQuestionDetailsViewControllerUserLikedUnlikedQuestionNotificationUserInfoLikedKey]];
            }];
			
        }
		else
		{
            if (completionBlock)
			{
                completionBlock(NO,error);
            }
        }
    }];
}


#pragma mark Facebook

+ (void)processFacebookProfilePictureData:(NSData *)newProfilePictureData
{
    if (newProfilePictureData.length == 0)
	{
        NSLog(@"Profile picture did not download successfully.");
        return;
    }
    
    // The user's Facebook profile picture is cached to disk. Check if the cached profile picture data matches the incoming profile picture. If it does, avoid uploading this data to Parse.
    NSURL *cachesDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject]; // iOS Caches directory
    NSURL *profilePictureCacheURL = [cachesDirectoryURL URLByAppendingPathComponent:@"FacebookProfilePicture.jpg"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[profilePictureCacheURL path]])
	{
        // We have a cached Facebook profile picture
        NSData *oldProfilePictureData = [NSData dataWithContentsOfFile:[profilePictureCacheURL path]];
		
        if ([oldProfilePictureData isEqualToData:newProfilePictureData])
		{
            NSLog(@"Cached profile picture matches incoming profile picture. Will not update.");
            return;
        }
    }
	
    BOOL cachedToDisk = [[NSFileManager defaultManager] createFileAtPath:[profilePictureCacheURL path] contents:newProfilePictureData attributes:nil];
    NSLog(@"Wrote profile picture to disk cache: %d", cachedToDisk);
	
    UIImage *image = [UIImage imageWithData:newProfilePictureData];
	
    UIImage *mediumImage = [image thumbnailImage:280 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
    UIImage *smallRoundedImage = [image thumbnailImage:64 transparentBorder:0 cornerRadius:9 interpolationQuality:kCGInterpolationLow];
	
    NSData *mediumImageData = UIImageJPEGRepresentation(mediumImage, 0.5); // using JPEG for larger pictures
    NSData *smallRoundedImageData = UIImagePNGRepresentation(smallRoundedImage);
	
    if (mediumImageData.length > 0)
	{
        NSLog(@"Uploading Medium Profile Picture");
        PFFile *fileMediumImage = [PFFile fileWithData:mediumImageData];
        [fileMediumImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
		{
            if (!error)
			{
                NSLog(@"Uploaded Medium Profile Picture");
                [[PFUser currentUser] setObject:fileMediumImage forKey:kOAUserProfilePicMediumKey];
                [[PFUser currentUser] saveEventually];
            }
        }];
    }
    
    if (smallRoundedImageData.length > 0)
	{
        NSLog(@"Uploading Profile Picture Thumbnail");
        PFFile *fileSmallRoundedImage = [PFFile fileWithData:smallRoundedImageData];
        [fileSmallRoundedImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
		{
            if (!error)
			{
                NSLog(@"Uploaded Profile Picture Thumbnail");
                [[PFUser currentUser] setObject:fileSmallRoundedImage forKey:kOAUserProfilePicSmallKey];
                [[PFUser currentUser] saveEventually];
            }
        }];
    }
}

+ (BOOL)userHasValidFacebookData:(PFUser *)user
{
    NSString *facebookId = [user objectForKey:kOAUserFacebookIDKey];
    return (facebookId && facebookId.length > 0);
}

+ (BOOL)userHasProfilePictures:(PFUser *)user
{
    PFFile *profilePictureMedium = [user objectForKey:kOAUserProfilePicMediumKey];
    PFFile *profilePictureSmall = [user objectForKey:kOAUserProfilePicSmallKey];
    
    return (profilePictureMedium && profilePictureSmall);
}


#pragma mark Display Name

+ (NSString *)firstNameForDisplayName:(NSString *)displayName
{
    if (!displayName || displayName.length == 0)
	{
        return @"Someone";
    }
    
    NSArray *displayNameComponents = [displayName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *firstName = [displayNameComponents objectAtIndex:0];
    
	if (firstName.length > 100)
	{
        // truncate to 100 so that it fits in a Push payload
        firstName = [firstName substringToIndex:100];
    }
    return firstName;
}


#pragma mark User Following

+ (void)followUserInBackground:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock
{
    if ([[user objectId] isEqualToString:[[PFUser currentUser] objectId]])
	{
        return;
    }
    
    PFObject *followActivity = [PFObject objectWithClassName:kOAActivityClassKey];
    [followActivity setObject:[PFUser currentUser] forKey:kOAActivityFromUserKey];
    [followActivity setObject:user forKey:kOAActivityToUserKey];
    [followActivity setObject:kOAActivityTypeFollow forKey:kOAActivityTypeKey];
    
    PFACL *followACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [followACL setPublicReadAccess:YES];
    followActivity.ACL = followACL;
    
    [followActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
	{
        if (completionBlock)
		{
            completionBlock(succeeded, error);
        }
        
        if (succeeded)
		{
            [OAUtility sendFollowingPushNotification:user];
        }
    }];
    [[OACache sharedCache] setFollowStatus:YES user:user];
}

+ (void)followUserEventually:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock
{
    if ([[user objectId] isEqualToString:[[PFUser currentUser] objectId]])
	{
        return;
    }
    
    PFObject *followActivity = [PFObject objectWithClassName:kOAActivityClassKey];
    [followActivity setObject:[PFUser currentUser] forKey:kOAActivityFromUserKey];
    [followActivity setObject:user forKey:kOAActivityToUserKey];
    [followActivity setObject:kOAActivityTypeFollow forKey:kOAActivityTypeKey];
    
    PFACL *followACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [followACL setPublicReadAccess:YES];
    followActivity.ACL = followACL;
    
    [followActivity saveEventually:completionBlock];
    [[OACache sharedCache] setFollowStatus:YES user:user];
}

+ (void)followUsersEventually:(NSArray *)users block:(void (^)(BOOL succeeded, NSError *error))completionBlock
{
    for (PFUser *user in users)
	{
        [OAUtility followUserEventually:user block:completionBlock];
        [[OACache sharedCache] setFollowStatus:YES user:user];
    }
}

+ (void)unfollowUserEventually:(PFUser *)user
{
    PFQuery *query = [PFQuery queryWithClassName:kOAActivityClassKey];
    [query whereKey:kOAActivityFromUserKey equalTo:[PFUser currentUser]];
    [query whereKey:kOAActivityToUserKey equalTo:user];
    [query whereKey:kOAActivityTypeKey equalTo:kOAActivityTypeFollow];
    [query findObjectsInBackgroundWithBlock:^(NSArray *followActivities, NSError *error)
	{
        // While normally there should only be one follow activity returned, we can't guarantee that.    
        if (!error)
		{
            for (PFObject *followActivity in followActivities)
			{
                [followActivity deleteEventually];
            }
        }
    }];
    [[OACache sharedCache] setFollowStatus:NO user:user];
}

+ (void)unfollowUsersEventually:(NSArray *)users
{
    PFQuery *query = [PFQuery queryWithClassName:kOAActivityClassKey];
    [query whereKey:kOAActivityFromUserKey equalTo:[PFUser currentUser]];
    [query whereKey:kOAActivityToUserKey containedIn:users];
    [query whereKey:kOAActivityTypeKey equalTo:kOAActivityTypeFollow];
    [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error)
	{
        for (PFObject *activity in activities)
		{
            [activity deleteEventually];
        }
    }];
    for (PFUser *user in users)
	{
        [[OACache sharedCache] setFollowStatus:NO user:user];
    }
}


#pragma mark Push

+ (void)sendFollowingPushNotification:(PFUser *)user
{
    NSString *privateChannelName = [user objectForKey:kOAUserPrivateChannelKey];
    if (privateChannelName && privateChannelName.length != 0)
	{
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%@ is now following you on Anypic.", [OAUtility firstNameForDisplayName:[[PFUser currentUser] objectForKey:kOAUserDisplayNameKey]]], kAPNSAlertKey,
                              kOAPushPayloadPayloadTypeActivityKey, kOAPushPayloadPayloadTypeKey,
                              kOAPushPayloadActivityFollowKey, kOAPushPayloadActivityTypeKey,
                              [[PFUser currentUser] objectId], kOAPushPayloadFromUserObjectIdKey,
                              nil];
        PFPush *push = [[PFPush alloc] init];
        [push setChannel:privateChannelName];
        [push setData:data];
        [push sendPushInBackground];
    }
}

#pragma mark Activities

+ (PFQuery *)queryForActivitiesOnPhoto:(PFObject *)photo cachePolicy:(PFCachePolicy)cachePolicy
{
    PFQuery *queryLikes = [PFQuery queryWithClassName:kOAActivityClassKey];
    [queryLikes whereKey:kOAActivityQuestionKey equalTo:photo];
    [queryLikes whereKey:kOAActivityTypeKey equalTo:kOAActivityTypeLike];
    
    PFQuery *queryComments = [PFQuery queryWithClassName:kOAActivityClassKey];
    [queryComments whereKey:kOAActivityQuestionKey equalTo:photo];
    [queryComments whereKey:kOAActivityTypeKey equalTo:kOAActivityTypeComment];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryLikes,queryComments,nil]];
    [query setCachePolicy:cachePolicy];
    [query includeKey:kOAActivityFromUserKey];
    [query includeKey:kOAActivityQuestionKey];
	
    return query;
}


#pragma mark Shadow Rendering

+ (void)drawSideAndBottomDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context
{
    // Push the context
    CGContextSaveGState(context);
    
    // Set the clipping path to remove the rect drawn by drawing the shadow
    CGRect boundingRect = CGContextGetClipBoundingBox(context);
    CGContextAddRect(context, boundingRect);
    CGContextAddRect(context, rect);
    CGContextEOClip(context);
    // Also clip the top and bottom
    CGContextClipToRect(context, CGRectMake(rect.origin.x - 10.0f, rect.origin.y, rect.size.width + 20.0f, rect.size.height + 10.0f));
    
    // Draw shadow
    [[UIColor blackColor] setFill];
    CGContextSetShadow(context, CGSizeMake(0.0f, 0.0f), 7.0f);
    CGContextFillRect(context, CGRectMake(rect.origin.x,
                                          rect.origin.y - 5.0f,
                                          rect.size.width,
                                          rect.size.height + 5.0f));
    // Save context
    CGContextRestoreGState(context);
}

+ (void)drawSideAndTopDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context
{
    // Push the context
    CGContextSaveGState(context);
    
    // Set the clipping path to remove the rect drawn by drawing the shadow
    CGRect boundingRect = CGContextGetClipBoundingBox(context);
    CGContextAddRect(context, boundingRect);
    CGContextAddRect(context, rect);
    CGContextEOClip(context);
    // Also clip the top and bottom
    CGContextClipToRect(context, CGRectMake(rect.origin.x - 10.0f, rect.origin.y - 10.0f, rect.size.width + 20.0f, rect.size.height + 10.0f));
    
    // Draw shadow
    [[UIColor blackColor] setFill];
    CGContextSetShadow(context, CGSizeMake( 0.0f, 0.0f), 7.0f);
    CGContextFillRect(context, CGRectMake(rect.origin.x,
                                          rect.origin.y,
                                          rect.size.width,
                                          rect.size.height + 10.0f));
    // Save context
    CGContextRestoreGState(context);
}

+ (void)drawSideDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context
{
    // Push the context
    CGContextSaveGState(context);
    
    // Set the clipping path to remove the rect drawn by drawing the shadow
    CGRect boundingRect = CGContextGetClipBoundingBox(context);
    CGContextAddRect(context, boundingRect);
    CGContextAddRect(context, rect);
    CGContextEOClip(context);
    // Also clip the top and bottom
    CGContextClipToRect(context, CGRectMake(rect.origin.x - 10.0f, rect.origin.y, rect.size.width + 20.0f, rect.size.height));
    
    // Draw shadow
    [[UIColor blackColor] setFill];
    CGContextSetShadow(context, CGSizeMake( 0.0f, 0.0f), 7.0f);
    CGContextFillRect(context, CGRectMake(rect.origin.x,
                                          rect.origin.y - 5.0f,
                                          rect.size.width,
                                          rect.size.height + 10.0f));
    // Save context
    CGContextRestoreGState(context);
}

+ (void)addBottomDropShadowToNavigationBarForNavigationController:(UINavigationController *)navigationController
{
    UIView *gradientView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, navigationController.navigationBar.frame.size.height, navigationController.navigationBar.frame.size.width, 3.0f)];
    [gradientView setBackgroundColor:[UIColor clearColor]];
    
    //CAGradientLayer *gradient = [CAGradientLayer layer];
    //gradient.frame = gradientView.bounds;
    //gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];
    //[gradientView.layer insertSublayer:gradient atIndex:0];
    //navigationController.navigationBar.clipsToBounds = NO;
    //[navigationController.navigationBar addSubview:gradientView];
}

@end
