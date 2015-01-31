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

+ (void)load
{
    
    [self registerSubclass];
    
}

//This user adds a new question.
- (void)addNewQuestion:(NSString *)question
{
    BQQuestion* newQuestion = [BQQuestion object];
    
    newQuestion.user = self.username; //This user asked the question
    newQuestion.questionText = question;
    newQuestion.answers = nil; //no answers to the question yet
    newQuestion.answerCount = 0;
    
    [newQuestion save];
}

//This user adds a new answer to this question.
- (void)addNewAnswer:(NSString *)answer toQuestion:(BQQuestion *)thisQuestion
{
    
    //create, fill out, and save the new answer
    BQAnswer* newAnswer = [BQAnswer object];
//    newAnswer.user = [BQUser currentUser]; //FIXME: Parse won't save correctly due to pointer conflict
    newAnswer.answerText = answer;
    newAnswer.question = thisQuestion;
    newAnswer.votes = 0; //no votes yet
    [newAnswer save];
    
    //associate the answer with this question, increment answer count, and save the question.
    [thisQuestion addObject:newAnswer forKey:@"answers"];
    [thisQuestion incrementKey:@"answerCount"];
    [thisQuestion save];
    
}

//This user increments this answer's vote count.
- (void)likeAnswer:(BQAnswer *)answer
{
    answer.votes++;
}

@end
