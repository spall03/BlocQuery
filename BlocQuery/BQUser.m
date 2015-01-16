//
//  BQUser.m
//  BlocQuery
//
//  Created by Stephen Palley on 1/13/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//


#import <Parse/PFObject+Subclass.h>
#import "BQUser.h"
#import "BQAnswer.h"
#import "BQQuestion.h"

@interface BQUser ()

@end

@implementation BQUser

@dynamic userDescription;
@dynamic userImage;

+ (void)load {
    
    [self registerSubclass];
    
}

//This user adds a new question.
- (BQQuestion*) addNewQuestion:(NSString *) question
{
    BQQuestion* newQuestion = [BQQuestion object];
    
    newQuestion.user = self.username; //This user asked the question
    newQuestion.questionText = question;
    newQuestion.answers = nil; //no answers to the question yet
    newQuestion.answerCount = 0;
    
    return newQuestion;
}

//This user adds a new answer to this question.
- (BQAnswer*) addNewAnswer:(NSString *) answer toQuestion:(BQQuestion *) thisQuestion
{
    BQAnswer* newAnswer = [BQAnswer object];
    
    newAnswer.user = self.username; //This user provided the answer
    newAnswer.answerText = answer;
    newAnswer.question = thisQuestion;
    newAnswer.votes = 0; //no votes yet
    
    return newAnswer;
}

//This user increments this answer's vote count.
- (void) likeAnswer:(BQAnswer *) answer
{
    answer.votes++;
}

@end
