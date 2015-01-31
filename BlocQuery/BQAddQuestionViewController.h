//
//  BQAddQuestionViewController.h
//  BlocQuery
//
//  Created by Stephen Palley on 1/30/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BQAddQuestionViewController;

@protocol BQAddQuestionViewControllerDelegate <NSObject>

- (void)addQuestionVCDidAddQuestion:(BQAddQuestionViewController*)sender;
- (void)addQuestionVCDidCancel:(BQAddQuestionViewController*)sender;


@end

@interface BQAddQuestionViewController : UIViewController

@property (nonatomic, weak) NSObject <BQAddQuestionViewControllerDelegate> *delegate;

@end
