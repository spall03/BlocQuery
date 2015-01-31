//
//  BQAddQuestionView.h
//  BlocQuery
//
//  Created by Stephen Palley on 1/30/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BQAddQuestionView;

@protocol BQAddQuestionViewDelegate <NSObject>

@optional

- (void) addQuestionViewDidAddQuestion:(BQAddQuestionView*)sender;
- (void) addQuestionViewWasCanceled:(BQAddQuestionView*)sender;

@end

@interface BQAddQuestionView : UIView

@property (nonatomic, weak) NSObject <BQAddQuestionViewDelegate> *delegate;

-(instancetype)initWithFrame:(CGRect)frame;

@end
