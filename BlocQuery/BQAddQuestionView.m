//
//  BQAddQuestionView.m
//  BlocQuery
//
//  Created by Stephen Palley on 1/30/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import "BQAddQuestionView.h"
#import "BQQuestion.h"
#import "BQUser.h"
#import <Parse/Parse.h>

@interface BQAddQuestionView () <UITextViewDelegate>

@property (nonatomic, strong) UILabel *addNewQuestionLabel;
@property (nonatomic, strong) UILabel *exampleQuestionLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UITextView *textView;

@end

@implementation BQAddQuestionView

-(id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor grayColor];
        self.layer.cornerRadius = 9.0f;

        
        //setup the top label for the window
        self.addNewQuestionLabel = [[UILabel alloc] init];
        self.addNewQuestionLabel.backgroundColor = [UIColor whiteColor];
        self.addNewQuestionLabel.text = @"Add a new question";
        
        NSLog(@"Frame for view; %@", NSStringFromCGRect( frame) );
        
        //setup the cancel button
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        //setup the submit button
        self.submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
        [self.submitButton addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
        //setup the text field
        self.textView = [[UITextView alloc] init];
        self.textView.text = @"Write your question here.";
        
        //setup the example label
        self.exampleQuestionLabel = [[UILabel alloc] init];
        self.exampleQuestionLabel.backgroundColor = [UIColor whiteColor];
        self.exampleQuestionLabel.text = NSLocalizedString(@"Example question: how now, brown cow?", @"Example Question"); // FIXME: We'll want to adjust the number of lines we're showing and make it able to handle a wide variety of sample questions... or at least a small variety of them

        //add as subviews and setup for autolayout
        for (UIView *viewToAdd in @[self.cancelButton, self.addNewQuestionLabel, self.submitButton, self.textView, self.exampleQuestionLabel])
        {
            [self addSubview:viewToAdd];
            viewToAdd.translatesAutoresizingMaskIntoConstraints = NO;
        }
        NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_addNewQuestionLabel, _cancelButton, _submitButton, _textView, _exampleQuestionLabel);
        NSDictionary *metrics = @{@"padding":@10.0};
        
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cancelButton(==50)]-[_addNewQuestionLabel]-[_submitButton(==50)]|" options:NSLayoutFormatAlignAllCenterY metrics:metrics views:viewDictionary]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[_textView]-padding-|" options:kNilOptions metrics:metrics views:viewDictionary]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[_exampleQuestionLabel]-padding-|" options:kNilOptions metrics:metrics views:viewDictionary]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[_cancelButton]-[_textView(==300)]-[_exampleQuestionLabel]-padding-|" options:kNilOptions metrics:metrics views:viewDictionary]];
    }
    
    
    return self;
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)cancelButtonPressed:(id)sender
{
    
    [self.delegate addQuestionViewWasCanceled:self];
    
}

-(void)submitButtonPressed:(id)sender
{
    // FIXME: Saving the data probably isn't best left in the view class... we might want to relocate this to our owning view controller... the BQQuestionTableViewController.
    [[BQUser currentUser] addNewQuestion:self.textView.text];
    [self.delegate addQuestionViewDidAddQuestion:self];
    
}
@end
