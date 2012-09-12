//
//  OAConstants.h
//  OneApp
//
//  Created by Dane Hesseldahl on 9/11/12.
//  Copyright (c) 2012 Pierson Labs. All rights reserved.
//

typedef enum {
	OAHomeTabBarItemIndex = 0,
	OAEmptyTabBarItemIndex = 1,
	OAActivityTabBarItemIndex = 2
} OATabBarControllerViewControllerIndex;

#define QuestionAskedNotification @"kQuestionAskedNotification"

#pragma mark - NSUserDefaults
extern NSString *const kOAUserDefaultsActivityFeedViewControllerLastRefreshKey;
extern NSString *const kOAUserDefaultsCacheFacebookFriendsKey;

#pragma mark - Launch URLs

extern NSString *const kOALaunchURLHostTakePicture;


#pragma mark - NSNotification
extern NSString *const OAAppDelegateApplicationDidReceiveRemoteNotification;
extern NSString *const OAUtilityUserFollowingChangedNotification;
extern NSString *const OAUtilityUserLikedUnlikedQuestionCallbackFinishedNotification;
extern NSString *const OAUtilityDidFinishProcessingProfilePictureNotification;
extern NSString *const OATabBarControllerDidFinishEditingQuestionNotification;
extern NSString *const OATabBarControllerDidFinishImageFileUploadNotification;
extern NSString *const OAQuestionDetailsViewControllerUserDeletedQuestionNotification;
extern NSString *const OAQuestionDetailsViewControllerUserLikedUnlikedQuestionNotification;
extern NSString *const OAQuestionDetailsViewControllerUserCommentedOnQuestionNotification;


#pragma mark - User Info Keys
extern NSString *const OAQuestionDetailsViewControllerUserLikedUnlikedQuestionNotificationUserInfoLikedKey;
extern NSString *const kOAEditQuestionViewControllerUserInfoCommentKey;


#pragma mark - Installation Class

// Field keys
extern NSString *const kOAInstallationUserKey;
extern NSString *const kOAInstallationChannelsKey;


#pragma mark - PFObject Activity Class
// Class key
extern NSString *const kOAActivityClassKey;

// Field keys
extern NSString *const kOAActivityTypeKey;
extern NSString *const kOAActivityFromUserKey;
extern NSString *const kOAActivityToUserKey;
extern NSString *const kOAActivityContentKey;
extern NSString *const kOAActivityQuestionKey;

// Type values
extern NSString *const kOAActivityTypeLike;
extern NSString *const kOAActivityTypeFollow;
extern NSString *const kOAActivityTypeComment;
extern NSString *const kOAActivityTypeJoined;


#pragma mark - PFObject User Class
// Field keys
extern NSString *const kOAUserDisplayNameKey;
extern NSString *const kOAUserFacebookIDKey;
extern NSString *const kOAUserQuestionIDKey;
extern NSString *const kOAUserProfilePicSmallKey;
extern NSString *const kOAUserProfilePicMediumKey;
extern NSString *const kOAUserAlreadyAutoFollowedFacebookFriendsKey;
extern NSString *const kOAUserPrivateChannelKey;


#pragma mark - PFObject Question Class
// Class key
extern NSString *const kOAQuestionClassKey;

// Field keys
extern NSString *const kOAQuestionTextKey;
extern NSString *const kOAQuestionPictureKey;
extern NSString *const kOAQuestionThumbnailKey;
extern NSString *const kOAQuestionUserKey;
extern NSString *const kOAQuestionTypeKey;

#pragma mark - Cached Question Attributes
// keys
extern NSString *const kOAQuestionAttributesIsLikedByCurrentUserKey;
extern NSString *const kOAQuestionAttributesLikeCountKey;
extern NSString *const kOAQuestionAttributesLikersKey;
extern NSString *const kOAQuestionAttributesCommentCountKey;
extern NSString *const kOAQuestionAttributesCommentersKey;


#pragma mark - Cached User Attributes
// keys
extern NSString *const kOAUserAttributesQuestionCountKey;
extern NSString *const kOAUserAttributesIsFollowedByCurrentUserKey;


#pragma mark - PFPush Notification Payload Keys

extern NSString *const kAPNSAlertKey;
extern NSString *const kAPNSBadgeKey;
extern NSString *const kAPNSSoundKey;

extern NSString *const kOAPushPayloadPayloadTypeKey;
extern NSString *const kOAPushPayloadPayloadTypeActivityKey;

extern NSString *const kOAPushPayloadActivityTypeKey;
extern NSString *const kOAPushPayloadActivityLikeKey;
extern NSString *const kOAPushPayloadActivityCommentKey;
extern NSString *const kOAPushPayloadActivityFollowKey;

extern NSString *const kOAPushPayloadFromUserObjectIdKey;
extern NSString *const kOAPushPayloadToUserObjectIdKey;
extern NSString *const kOAPushPayloadQuestionObjectIdKey;
