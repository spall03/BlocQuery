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

@class BQTableCellView;

@protocol BQTableCellViewDelegate <NSObject>

@optional

- (void) tableCellViewDidPressProfilePicture:(BQTableCellView*)sender;
- (void) tableCellViewDidPressTextField:(BQTableCellView*)sender;
- (void) tableCellViewDidPressVoteButton:(BQTableCellView*)sender;

@end

@interface BQTableCellView : UITableViewCell

@property (nonatomic, weak) NSObject <BQTableCellViewDelegate> *delegate;

+ (CGFloat)cellHeightForText:(NSString *)text width:(CGFloat)width;

- (void) setCellImage:(PFFile *)image cellText:(NSString *)text cellSecondaryText:(NSString *)secondaryText andVoteButton:(BOOL)button;

@end
