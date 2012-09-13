//
//  OAConstants.m
//  OneApp
//
//  Created by Dane Hesseldahl on 9/11/12.
//  Copyright (c) 2012 Pierson Labs. All rights reserved.
//

#import "OAConstants.h"

NSString *const kOAUserDefaultsActivityFeedViewControllerLastRefreshKey    = @"com.parse.Anypic.userDefaults.activityFeedViewController.lastRefresh";
NSString *const kOAUserDefaultsCacheFacebookFriendsKey                     = @"com.parse.Anypic.userDefaults.cache.facebookFriends";


#pragma mark - Launch URLs

NSString *const kOALaunchURLHostTakePicture = @"camera";


#pragma mark - NSNotification

NSString *const OAAppDelegateApplicationDidReceiveRemoteNotification           = @"com.parse.Anypic.appDelegate.applicationDidReceiveRemoteNotification";
NSString *const OAUtilityUserFollowingChangedNotification                      = @"com.parse.Anypic.utility.userFollowingChanged";
NSString *const OAUtilityUserLikedUnlikedQuestionCallbackFinishedNotification     = @"com.parse.Anypic.utility.userLikedUnlikedPhotoCallbackFinished";
NSString *const OAUtilityDidFinishProcessingProfilePictureNotification         = @"com.parse.Anypic.utility.didFinishProcessingProfilePictureNotification";
NSString *const OATabBarControllerDidFinishEditingQuestionNotification            = @"com.parse.Anypic.tabBarController.didFinishEditingPhoto";
NSString *const OATabBarControllerDidFinishImageFileUploadNotification         = @"com.parse.Anypic.tabBarController.didFinishImageFileUploadNotification";
NSString *const OAQuestionDetailsViewControllerUserDeletedQuestionNotification       = @"com.parse.Anypic.photoDetailsViewController.userDeletedPhoto";
NSString *const OAQuestionDetailsViewControllerUserLikedUnlikedQuestionNotification  = @"com.parse.Anypic.photoDetailsViewController.userLikedUnlikedPhotoInDetailsViewNotification";
NSString *const OAQuestionDetailsViewControllerUserCommentedOnQuestionNotification   = @"com.parse.Anypic.photoDetailsViewController.userCommentedOnPhotoInDetailsViewNotification";


#pragma mark - User Info Keys
NSString *const OAQuestionDetailsViewControllerUserLikedUnlikedQuestionNotificationUserInfoLikedKey = @"liked";
NSString *const kOAEditQuestionViewControllerUserInfoCommentKey = @"comment";

#pragma mark - Installation Class

// Field keys
NSString *const kOAInstallationUserKey = @"user";
NSString *const kOAInstallationChannelsKey = @"channels";

#pragma mark - Activity Class
// Class key
NSString *const kOAActivityClassKey = @"Activity";

// Field keys
NSString *const kOAActivityTypeKey        = @"type";
NSString *const kOAActivityFromUserKey    = @"fromUser";
NSString *const kOAActivityToUserKey      = @"toUser";
NSString *const kOAActivityContentKey     = @"content";
NSString *const kOAActivityQuestionKey       = @"Question";

// Type values
NSString *const kOAActivityTypeLike       = @"like";
NSString *const kOAActivityTypeFollow     = @"follow";
NSString *const kOAActivityTypeComment    = @"comment";
NSString *const kOAActivityTypeJoined     = @"joined";

#pragma mark - User Class
// Field keys
NSString *const kOAUserDisplayNameKey                          = @"displayName";
NSString *const kOAUserFacebookIDKey                           = @"facebookId";
NSString *const kOAUserQuestionIDKey                              = @"questionId";
NSString *const kOAUserProfilePicSmallKey                      = @"profilePictureSmall";
NSString *const kOAUserProfilePicMediumKey                     = @"profilePictureMedium";
NSString *const kOAUserAlreadyAutoFollowedFacebookFriendsKey   = @"userAlreadyAutoFollowedFacebookFriends";
NSString *const kOAUserPrivateChannelKey                       = @"channel";

#pragma mark - Question Class
// Class key
NSString *const kOAQuestionClassKey				= @"Question";

// Field keys
NSString *const kOAQuestionTextKey			  = @"text";
NSString *const kOAQuestionPictureKey         = @"image";
NSString *const kOAQuestionThumbnailKey       = @"thumbnail";
NSString *const kOAQuestionUserKey            = @"user";
NSString *const kOAQuestionTypeKey			  = @"type";
NSString *const kOAQuestionCategoryKey		  = @"";

#pragma mark - Cached Question Attributes
// keys
NSString *const kOAQuestionAttributesIsLikedByCurrentUserKey = @"isLikedByCurrentUser";
NSString *const kOAQuestionAttributesLikeCountKey            = @"likeCount";
NSString *const kOAQuestionAttributesLikersKey               = @"likers";
NSString *const kOAQuestionAttributesCommentCountKey         = @"commentCount";
NSString *const kOAQuestionAttributesCommentersKey           = @"commenters";


#pragma mark - Cached User Attributes
// keys
NSString *const kOAUserAttributesQuestionCountKey                 = @"questionCount";
NSString *const kOAUserAttributesIsFollowedByCurrentUserKey    = @"isFollowedByCurrentUser";


#pragma mark - Push Notification Payload Keys

NSString *const kAPNSAlertKey = @"alert";
NSString *const kAPNSBadgeKey = @"badge";
NSString *const kAPNSSoundKey = @"sound";

// the following keys are intentionally kept short, APNS has a maximum payload limit
NSString *const kOAPushPayloadPayloadTypeKey          = @"p";
NSString *const kOAPushPayloadPayloadTypeActivityKey  = @"a";

NSString *const kOAPushPayloadActivityTypeKey     = @"t";
NSString *const kOAPushPayloadActivityLikeKey     = @"l";
NSString *const kOAPushPayloadActivityCommentKey  = @"c";
NSString *const kOAPushPayloadActivityFollowKey   = @"f";

NSString *const kOAPushPayloadFromUserObjectIdKey = @"fu";
NSString *const kOAPushPayloadToUserObjectIdKey   = @"tu";
NSString *const kOAPushPayloadQuestionObjectIdKey    = @"pid";