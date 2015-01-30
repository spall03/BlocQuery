//
//  BQAnswerQuestionView.m
//  BlocQuery
//
//  Created by Stephen Palley on 1/27/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import "BQAnswerQuestionView.h"
#import "BQAnswer.h"
#import "BQUser.h"

@interface BQAnswerQuestionView () <UITextViewDelegate>

@property (nonatomic, assign) BOOL isAnswering;

@end

@implementation BQAnswerQuestionView

//initializes a new AnswerQuestionView for the given question, in the given location
- (id)initWithFrame:(CGRect)frame andQuestion:(BQQuestion*) question
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.question = question;
        
        self.backgroundColor = [UIColor yellowColor];
        
        self.textView = [UITextView new];
        self.textView.delegate = self;
        
        //setup a button to submit new answers
        self.submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.submitButton.backgroundColor = [UIColor whiteColor];
        [self.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
        [self.submitButton addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
       
        
        //setup a button to submit new answers
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.cancelButton.backgroundColor = [UIColor whiteColor];
        [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

        
        //display the question text first
        NSString *questionString = [NSString stringWithFormat:@"%@", self.question.questionText];
        self.questionLabel = [[UILabel alloc] init];
        self.questionLabel.text = questionString;
        self.questionLabel.textAlignment = NSTextAlignmentCenter;
        
        
        [self addSubview:self.questionLabel];
        [self addSubview:self.textView];
        
        [self addSubview:self.submitButton];
        [self addSubview:self.cancelButton];

        self.isAnswering = NO;
        
    }
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self.questionLabel sizeToFit];
}

//center our question label in the middle of our label view
- (void)layoutSubviews
{
    [super layoutSubviews];
    if ( self.isAnswering )
    {
        float bottommostY = CGRectGetMaxY( self.questionLabel.frame ); // TODO: For now we'll pin our text view to the bottom of our question view... though before
        
        self.textView.hidden = NO;
        self.textView.frame = CGRectMake(self.bounds.origin.x, bottommostY, self.bounds.size.width, 400.0);
        // TODO: Is the intention that the text view drops so far below the question label?
        self.textView.backgroundColor = [UIColor lightGrayColor];
        self.textView.editable = YES;
        self.textView.userInteractionEnabled = YES;
    
        self.submitButton.hidden = NO; // TODO: These guys are no longer subviews of our text view.
        self.cancelButton.hidden = NO;
        [self.submitButton sizeToFit];
        [self.cancelButton sizeToFit];
        
        self.cancelButton.frame = CGRectMake(
                                             ( CGRectGetMaxX( self.textView.frame ) - ( self.cancelButton.frame.size.width + self.submitButton.frame.size.width + 50 ) ),
                                             ( bottommostY + ( self.cancelButton.frame.size.height + 25 ) ),
                                             self.cancelButton.frame.size.width,
                                             self.cancelButton.frame.size.height );
        self.submitButton.frame = CGRectMake(
                                             ( CGRectGetMaxX( self.textView.frame ) - ( self.submitButton.frame.size.width + 30 )),
                                             ( bottommostY + ( self.submitButton.frame.size.height + 25 ) ),
                                             self.submitButton.frame.size.width,
                                             self.submitButton.frame.size.height );
        self.submitButton.userInteractionEnabled = YES;
        self.cancelButton.userInteractionEnabled = YES;
    }
    else
    {
        self.textView.hidden = YES;
        self.submitButton.hidden = YES; // TODO: These guys are no longer subviews of our text view.
        self.cancelButton.hidden = YES;
    }
}

- (void)startTextEditing
{
    self.isAnswering = YES;
    NSLog(@"start text editing!");
    self.textView.text = @"Answer here.";
    
    self.submitButton.userInteractionEnabled = YES;
    self.cancelButton.userInteractionEnabled = YES;
    [self layoutSubviews];
}

- (void)submitButtonPressed:(id)sender
{
    
    NSLog(@"Submit comment!");
    
    //invoke user method for adding new answers to questions
    [[BQUser currentUser] addNewAnswer:self.textView.text toQuestion:self.question];
    
    //reset textfield and put it away
    self.textView.text = @"Answer here."; // TODO: Do you want this to override what the user has typed and maybe canceled? Do you want to leave their typed text if they cancel and then decide to try and re-answer?
    
    //need to then refresh the parent view controller
    [self.delegate answerQuestionViewDidAddAnswer:self];
    
    self.isAnswering = NO;
    [self layoutSubviews];
}

- (void)cancelButtonPressed:(id)sender
{

    NSLog(@"Cancel comment!");

    self.isAnswering = NO;
    [self layoutSubviews];
}





@end
