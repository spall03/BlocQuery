//
//  BQTableCellView.h
//  BlocQuery
//
//  Created by Stephen Palley on 2/13/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI.h>
#import <Parse/Parse.h>
#import "BQUser.h"

@class BQTableCellView;

@protocol BQTableCellViewDelegate <NSObject>

- (void) tableCellViewDidPressProfilePicture:(BQTableCellView*)sender;

@optional

- (void) tableCellViewDidPressTextField:(BQTableCellView*)sender;
- (void) tableCellViewDidPressVoteButton:(BQTableCellView*)sender;

@end

@interface BQTableCellView : UITableViewCell

@property (nonatomic, weak) NSObject <BQTableCellViewDelegate> *delegate;
@property (nonatomic, strong) UIButton *voteButton; //hidden for question table view cells


+ (CGFloat)cellHeightForText:(NSString *)text width:(CGFloat)width;

- (void) setCellImage:(PFFile *)image cellUserName:(NSString *)name placeholderImage:(UIImage *)placeholderImage cellText:(NSString *)text cellSecondaryText:(NSString *)secondaryText andVoteButton:(BOOL)button;
//- (void) changeVoteButtonText;


- (BQUser *) getUser;
- (BQQuestion *) getQuestion;
- (BQAnswer *) getAnswer;

@end
