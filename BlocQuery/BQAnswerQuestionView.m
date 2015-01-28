//
//  BQAnswerQuestionView.m
//  BlocQuery
//
//  Created by Stephen Palley on 1/27/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import "BQAnswerQuestionView.h"

@interface BQAnswerQuestionView () <UITextViewDelegate>

@end

@implementation BQAnswerQuestionView

//initializes a new AnswerQuestionView for the given question, in the given location
- (id)initWithFrame:(CGRect)frame andQuestion:(BQQuestion*) question
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.question = question;
        
        self.textView = [UITextView new];
        self.textView.delegate = self;
        
        //setup a button to submit new answers
        self.submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
        [self.submitButton addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        //setup a button to submit new answers
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        //display the question text first
        NSString *questionString = [NSString stringWithFormat:@"%@", self.question.questionText];
        self.questionLabel = [[UILabel alloc] init];
        self.questionLabel.text = questionString;
        self.questionLabel.textAlignment = NSTextAlignmentCenter;
        
        
        [self addSubview:self.questionLabel];
        
        self.questionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.textView.translatesAutoresizingMaskIntoConstraints = NO;
        
        
    }
    return self;
}

//center our question label in the middle of our label view
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.questionLabel sizeToFit];
    
    NSLayoutConstraint *xCenterConstraint = [NSLayoutConstraint constraintWithItem:self.questionLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self addConstraint:xCenterConstraint];
    
    NSLayoutConstraint *yCenterConstraint = [NSLayoutConstraint constraintWithItem:self.questionLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [self addConstraint:yCenterConstraint];

    
}

- (void)startTextEditing
{
    NSLog(@"start text editing!");
    
    [self addSubview:self.textView];

    [self.textView addSubview:self.submitButton];
    [self.textView addSubview:self.cancelButton];
    
    float bottomLeftCorner = CGRectGetMaxY(self.questionLabel.frame);
    
    //TODO: fix all of this for autolayout
    self.textView.frame = CGRectMake(self.bounds.origin.x, bottomLeftCorner, self.bounds.size.width, 400.0);
    self.textView.text = @"Answer here.";
    self.textView.backgroundColor = [UIColor lightGrayColor];
    self.textView.editable = YES;
    
    self.cancelButton.frame = CGRectMake(100.0, 350.0, 100.0, 100.0);
    self.submitButton.frame = CGRectMake(250.0, 350.0, 100.0, 100.0);
    
    [self.submitButton sizeToFit];
    [self.cancelButton sizeToFit];
    
}

//FIXME
- (void)submitButtonPressed:(UIButton*)sender
{
    
    NSLog(@"Submit comment!");
    
    
}

//FIXME
- (void)cancelButtonPressed:(UIButton*)sender
{

    NSLog(@"Cancel comment!");

    [self.textView removeFromSuperview];
    
    
}





@end
