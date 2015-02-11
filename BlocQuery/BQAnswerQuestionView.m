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
@property (nonatomic, assign) CGFloat originalHeight;

@end

@implementation BQAnswerQuestionView

//initializes a new AnswerQuestionView for the given question, in the given location
- (id)initWithFrame:(CGRect)frame andQuestion:(BQQuestion*) question
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.originalHeight = frame.size.height;
        
        self.question = question;
        
        self.userInteractionEnabled = YES;

        self.backgroundColor = [UIColor whiteColor];
        
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
        self.questionLabel.numberOfLines = 0; // Just let UIKit figure out how many lines we need
        self.questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.questionLabel.textAlignment = NSTextAlignmentCenter;
        
        self.questionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.questionLabel];
        self.textView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.textView];
        
        self.submitButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.submitButton];
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.cancelButton];
        
        NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_questionLabel, _textView, _submitButton, _cancelButton);
        NSDictionary *metrics = @{@"padding":@10.0};
        
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_questionLabel]|" options:NSLayoutFormatAlignAllCenterX metrics:metrics views:viewDictionary]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[_textView]-padding-|" options:kNilOptions metrics:metrics views:viewDictionary]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_cancelButton]-[_submitButton]|" options:NSLayoutFormatAlignAllCenterY metrics:metrics views:viewDictionary]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_questionLabel]-[_textView(==50)]-[_submitButton]" options:kNilOptions metrics:metrics views:viewDictionary]];


        self.isAnswering = NO;
    }
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];

    self.questionLabel.preferredMaxLayoutWidth = self.frame.size.width;
    
}

//center our question label in the middle of our label view
- (void)layoutSubviews
{
    [super layoutSubviews];
    if ( self.isAnswering )
    {
        
        self.textView.hidden = NO;
        self.textView.backgroundColor = [UIColor whiteColor];
        self.textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.textView.layer.borderWidth = 1.0f;
        self.textView.layer.cornerRadius = 9.0f;
        self.textView.editable = YES;
        self.textView.userInteractionEnabled = YES;
    
        self.submitButton.hidden = NO;
        self.cancelButton.hidden = NO;
        self.submitButton.userInteractionEnabled = YES;
        self.cancelButton.userInteractionEnabled = YES;

        // Calculate the height of our UIView so that our buttons can receive presses... if we don't do this the buttons are rendered outside of their parent view and will not receive touches without more work on our part.
        CGFloat totalHeight = 0.0f;
        for (UIView *view in self.subviews)
        {
            totalHeight = MAX( totalHeight, ( view.frame.origin.y + view.frame.size.height ) );
        }
        self.frame = CGRectMake( self.frame.origin.x, self.frame.origin.y, self.frame.size.width, totalHeight);
    }
    else
    {
        self.textView.hidden = YES;
        self.submitButton.hidden = YES;
        self.cancelButton.hidden = YES;
        self.frame = CGRectMake( self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.originalHeight);
    }
}

- (void)startTextEditing
{
    self.isAnswering = YES;
    NSLog(@"start text editing!");
    self.textView.text = @"Answer here.";
    
    self.submitButton.userInteractionEnabled = YES;
    self.cancelButton.userInteractionEnabled = YES;
    
    if ( [self.delegate respondsToSelector:@selector(didBeginAddingAnswer:)] )
    {
        [self.delegate didBeginAddingAnswer:self];
    }
    [self layoutSubviews];
}


- (void)submitButtonPressed:(id)sender
{    
    //need to then refresh the parent view controller
    [self.delegate answerQuestionViewDidAddAnswer:self withAnswer:self.textView.text];
    
    //reset textfield and put it away
    self.textView.text = @"Answer here."; // TODO: Do you want this to override what the user has typed and maybe canceled? Do you want to leave their typed text if they cancel and then decide to try and re-answer?
    
    
    self.isAnswering = NO;

    if ( [self.delegate respondsToSelector:@selector(didEndAddingAnswer:)] )
    {
        [self.delegate didEndAddingAnswer:self];
    }
    [self layoutSubviews];
}

- (void)cancelButtonPressed:(id)sender
{
    self.isAnswering = NO;
    if ( [self.delegate respondsToSelector:@selector(didEndAddingAnswer:)] )
    {
        [self.delegate didEndAddingAnswer:self];
    }
    [self layoutSubviews];
}





@end
