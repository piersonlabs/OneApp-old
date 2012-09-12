//
//  OACache.m
//  OneApp
//
//  Created by Dane Hesseldahl on 9/11/12.
//  Copyright (c) 2012 Pierson Labs. All rights reserved.
//

#import "OACache.h"

@interface OACache()

@property (nonatomic, strong) NSCache *cache;
- (void)setAttributes:(NSDictionary *)attributes forPhoto:(PFObject *)photo;
@end

@implementation OACache
@synthesize cache;

#pragma mark - Initialization

+ (id)sharedCache
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^
	{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init
{
    self = [super init];
    if (self)
	{
        self.cache = [[NSCache alloc] init];
    }
    return self;
}

#pragma mark - OACache

- (void)clear
{
    [self.cache removeAllObjects];
}

- (void)setAttributesForPhoto:(PFObject *)photo likers:(NSArray *)likers commenters:(NSArray *)commenters likedByCurrentUser:(BOOL)likedByCurrentUser
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
								[NSNumber numberWithBool:likedByCurrentUser],kOAQuestionAttributesIsLikedByCurrentUserKey,
								[NSNumber numberWithInt:[likers count]],kOAQuestionAttributesLikeCountKey,
								likers,kOAQuestionAttributesLikersKey,
								[NSNumber numberWithInt:[commenters count]],kOAQuestionAttributesCommentCountKey,
								commenters,kOAQuestionAttributesCommentersKey,
								nil];
    [self setAttributes:attributes forPhoto:photo];
}

- (NSDictionary *)attributesForPhoto:(PFObject *)photo
{
    NSString *key = [self keyForPhoto:photo];
    return [self.cache objectForKey:key];
}

- (NSNumber *)likeCountForPhoto:(PFObject *)photo
{
    NSDictionary *attributes = [self attributesForPhoto:photo];
    if (attributes)
	{
        return [attributes objectForKey:kOAQuestionAttributesLikeCountKey];
    }
	
    return [NSNumber numberWithInt:0];
}

- (NSNumber *)commentCountForPhoto:(PFObject *)photo
{
    NSDictionary *attributes = [self attributesForPhoto:photo];
    if (attributes)
	{
        return [attributes objectForKey:kOAQuestionAttributesCommentCountKey];
    }
    
    return [NSNumber numberWithInt:0];
}

- (NSArray *)likersForPhoto:(PFObject *)photo
{
    NSDictionary *attributes = [self attributesForPhoto:photo];
    if (attributes)
	{
        return [attributes objectForKey:kOAQuestionAttributesLikersKey];
    }
    
    return [NSArray array];
}

- (NSArray *)commentersForPhoto:(PFObject *)photo
{
    NSDictionary *attributes = [self attributesForPhoto:photo];
    if (attributes)
	{
        return [attributes objectForKey:kOAQuestionAttributesCommentersKey];
    }
    
    return [NSArray array];
}

- (void)setPhotoIsLikedByCurrentUser:(PFObject *)photo liked:(BOOL)liked
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForPhoto:photo]];
    [attributes setObject:[NSNumber numberWithBool:liked] forKey:kOAQuestionAttributesIsLikedByCurrentUserKey];
    [self setAttributes:attributes forPhoto:photo];
}

- (BOOL)isPhotoLikedByCurrentUser:(PFObject *)photo
{
    NSDictionary *attributes = [self attributesForPhoto:photo];
    if (attributes)
	{
        return [[attributes objectForKey:kOAQuestionAttributesIsLikedByCurrentUserKey] boolValue];
    }
    
    return NO;
}

- (void)incrementLikerCountForPhoto:(PFObject *)photo
{
    NSNumber *likerCount = [NSNumber numberWithInt:[[self likeCountForPhoto:photo] intValue] + 1];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForPhoto:photo]];
    [attributes setObject:likerCount forKey:kOAQuestionAttributesLikeCountKey];
    [self setAttributes:attributes forPhoto:photo];
}

- (void)decrementLikerCountForPhoto:(PFObject *)photo
{
    NSNumber *likerCount = [NSNumber numberWithInt:[[self likeCountForPhoto:photo] intValue] - 1];
    if ([likerCount intValue] < 0)
	{
        return;
    }
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForPhoto:photo]];
    [attributes setObject:likerCount forKey:kOAQuestionAttributesLikeCountKey];
    [self setAttributes:attributes forPhoto:photo];
}

- (void)incrementCommentCountForPhoto:(PFObject *)photo
{
    NSNumber *commentCount = [NSNumber numberWithInt:[[self commentCountForPhoto:photo] intValue] + 1];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForPhoto:photo]];
    [attributes setObject:commentCount forKey:kOAQuestionAttributesCommentCountKey];
    [self setAttributes:attributes forPhoto:photo];
}

- (void)decrementCommentCountForPhoto:(PFObject *)photo
{
    NSNumber *commentCount = [NSNumber numberWithInt:[[self commentCountForPhoto:photo] intValue] - 1];
    if ([commentCount intValue] < 0)
	{
        return;
    }
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForPhoto:photo]];
    [attributes setObject:commentCount forKey:kOAQuestionAttributesCommentCountKey];
    [self setAttributes:attributes forPhoto:photo];
}

- (void)setAttributesForUser:(PFUser *)user photoCount:(NSNumber *)count followedByCurrentUser:(BOOL)following
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                count,kOAUserAttributesQuestionCountKey,
                                [NSNumber numberWithBool:following],kOAUserAttributesIsFollowedByCurrentUserKey,
                                nil];
    [self setAttributes:attributes forUser:user];
}

- (NSDictionary *)attributesForUser:(PFUser *)user
{
    NSString *key = [self keyForUser:user];
    return [self.cache objectForKey:key];
}

- (NSNumber *)photoCountForUser:(PFUser *)user
{
    NSDictionary *attributes = [self attributesForUser:user];
    if (attributes)
	{
        NSNumber *photoCount = [attributes objectForKey:kOAUserAttributesQuestionCountKey];
        if (photoCount)
		{
            return photoCount;
        }
    }
    
    return [NSNumber numberWithInt:0];
}

- (BOOL)followStatusForUser:(PFUser *)user
{
    NSDictionary *attributes = [self attributesForUser:user];
    if (attributes)
	{
        NSNumber *followStatus = [attributes objectForKey:kOAUserAttributesIsFollowedByCurrentUserKey];
        if (followStatus)
		{
            return [followStatus boolValue];
        }
    }
	
    return NO;
}

- (void)setPhotoCount:(NSNumber *)count user:(PFUser *)user
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForUser:user]];
    [attributes setObject:count forKey:kOAUserAttributesQuestionCountKey];
    [self setAttributes:attributes forUser:user];
}

- (void)setFollowStatus:(BOOL)following user:(PFUser *)user
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForUser:user]];
    [attributes setObject:[NSNumber numberWithBool:following] forKey:kOAUserAttributesIsFollowedByCurrentUserKey];
    [self setAttributes:attributes forUser:user];
}

- (void)setFacebookFriends:(NSArray *)friends
{
    NSString *key = kOAUserDefaultsCacheFacebookFriendsKey;
    [self.cache setObject:friends forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:friends forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)facebookFriends
{
    NSString *key = kOAUserDefaultsCacheFacebookFriendsKey;
    if ([self.cache objectForKey:key])
	{
        return [self.cache objectForKey:key];
    }
    
    NSArray *friends = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (friends)
	{
        [self.cache setObject:friends forKey:key];
    }
	
    return friends;
}


#pragma mark - ()

- (void)setAttributes:(NSDictionary *)attributes forPhoto:(PFObject *)photo
{
    NSString *key = [self keyForPhoto:photo];
    [self.cache setObject:attributes forKey:key];
}

- (void)setAttributes:(NSDictionary *)attributes forUser:(PFUser *)user
{
    NSString *key = [self keyForUser:user];
    [self.cache setObject:attributes forKey:key];
}

- (NSString *)keyForPhoto:(PFObject *)photo
{
    return [NSString stringWithFormat:@"photo_%@", [photo objectId]];
}

- (NSString *)keyForUser:(PFUser *)user
{
    return [NSString stringWithFormat:@"user_%@", [user objectId]];
}

@end
