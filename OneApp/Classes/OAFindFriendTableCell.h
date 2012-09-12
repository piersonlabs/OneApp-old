//
//  OAFindFriendTableCell.h
//  OneApp
//
//  Created by Dane Hesseldahl on 9/11/12.
//  Copyright (c) 2012 Pierson Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFImageView;
@protocol OAFindFriendTableCellDelegate;

@interface OAFindFriendTableCell : UITableViewCell
{
    id _delegate;
}

@property (nonatomic, strong) id<OAFindFriendTableCellDelegate> delegate;

/*! The user represented in the cell */
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) UILabel *photoLabel;
@property (nonatomic, strong) UIButton *followButton;

/*! Setters for the cell's content */
- (void)setUser:(PFUser *)user;

- (void)didTapUserButtonAction:(id)sender;
- (void)didTapFollowButtonAction:(id)sender;

/*! Static Helper methods */
+ (CGFloat)heightForCell;

@end

/*!
 The protocol defines methods a delegate of a PAPBaseTextCell should implement.
 */
@protocol OAFindFriendTableCellDelegate <NSObject>
@optional

/*!
 Sent to the delegate when a user button is tapped
 @param aUser the PFUser of the user that was tapped
 */
- (void)cell:(OAFindFriendTableCell *)cellView didTapUserButton:(PFUser *)aUser;
- (void)cell:(OAFindFriendTableCell *)cellView didTapFollowButton:(PFUser *)aUser;

@end
