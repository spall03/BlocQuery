//
//  BQAnswerQuestionView.h
//  BlocQuery
//
//  Created by Stephen Palley on 1/27/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BQQuestion.h"

@interface BQAnswerQuestionView : UIView

@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) BQQuestion *question; //the question we're going to pull answers in for
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIButton *cancelButton;

- (id)initWithFrame:(CGRect)frame andQuestion:(BQQuestion*) question;
- (void)startTextEditing;

@end
