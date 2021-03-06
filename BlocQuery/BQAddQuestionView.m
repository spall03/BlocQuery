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

static UIFont *smallFont;

@implementation BQAddQuestionView

-(id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor grayColor];
        self.layer.cornerRadius = 9.0f;
        smallFont = [UIFont fontWithName:@"HelveticaNeue-Italic" size:8];

        
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
        self.exampleQuestionLabel.font = smallFont;
        self.exampleQuestionLabel.numberOfLines = 0;
        [PFConfig getConfigInBackgroundWithBlock:^(PFConfig *config, NSError *error) {
            
            if (config)
            {
                NSString *sampleQuestion = config[@"BQSampleQuestion"];
                self.exampleQuestionLabel.text = [NSString stringWithFormat:@"Sample question: %@", sampleQuestion];
            }
            else
            {
                NSLog(@"Sample question didn't load, and here's why: %@", error);
                self.exampleQuestionLabel.text = @"Sample question: why didn't the sample question load properly?";
            }
        }];

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

    [self.delegate addQuestionViewDidAddQuestion:self withQuestionText:self.textView.text];
    
}
@end
