//
//  BQAddQuestionView.m
//  BlocQuery
//
//  Created by Stephen Palley on 1/30/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import "BQAddQuestionView.h"

@interface BQAddQuestionView ()

@property (nonatomic, strong) UILabel *addNewQuestionLabel;
@property (nonatomic, strong) UILabel *exampleQuestionLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UIView *topNavContainer;

@end

@implementation BQAddQuestionView

-(id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        
        //setup the top label for the window
        self.addNewQuestionLabel = [[UILabel alloc] init];
        self.addNewQuestionLabel.backgroundColor = [UIColor whiteColor];
        self.addNewQuestionLabel.text = @"Add a new question";
        
        //setup the cancel button
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        
        //setup the submit button
        self.submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
        [self.submitButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    
        //setup the text field
        self.textView = [[UITextView alloc]init];
        self.textView.text = @"Write your question here.";
        
        //setup the example label
        self.exampleQuestionLabel = [[UILabel alloc] init];
        self.exampleQuestionLabel.backgroundColor = [UIColor whiteColor];
        self.exampleQuestionLabel.text = NSLocalizedString(@"Example question: how now, brown cow?", @"Example Question");
        
//        //setup the container for the top nav bar and add the nav bar elements
//        self.topNavContainer = [[UIView alloc]init];
//        for (UIView *viewToAdd in @[self.addNewQuestionLabel, self.cancelButton, self.submitButton])
//        {
//            [self.topNavContainer addSubview:viewToAdd];
//            viewToAdd.translatesAutoresizingMaskIntoConstraints = NO;
//        }
        

        //add as subviews and setup for autolayout
        for (UIView *viewToAdd in @[self.cancelButton, self.addNewQuestionLabel, self.submitButton, self.textView, self.exampleQuestionLabel])
        {
            [self addSubview:viewToAdd];
            viewToAdd.translatesAutoresizingMaskIntoConstraints = NO;
        }
    
    
    }
    
    
    return self;
    
}

-(void)layoutSubviews
{
    
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_addNewQuestionLabel, _cancelButton, _submitButton, _textView, _exampleQuestionLabel);
    
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cancelButton]-[_addNewQuestionLabel]-[_submitButton]|" options:kNilOptions metrics:nil views:viewDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_cancelButton]-[_textView]-[_exampleQuestionLabel]|" options:kNilOptions metrics:nil views:viewDictionary]];
    
    
//    //first, lay out the elements of the top nav bar
//    [self.topNavContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cancelButton][_addNewQuestionLabel][_submitButton]|" options:kNilOptions metrics:nil views:viewDictionary]];
//    
//    //then stack everything vertically
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topNavContainer][_textView][_exampleQuestionLabel]|" options:kNilOptions metrics:nil views:viewDictionary]];
    
    
}

@end
