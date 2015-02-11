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

NSString *const kBQDidPostNewAnswerToQuestion = @"BQDidPostNewAnswerToQuestion";
NSString *const kBQActiveUserDidLogOut = @"BQActiveUserDidLogOut";

@interface BQUser ()

@end

@implementation BQUser

@dynamic userDescription;
@dynamic userImage;

+ (void)load
{
    
    [self registerSubclass];
    
}

- (PFFile*)setDefaultProfileImage
{
    
    PFFile *tempImageFile;
    
    PFConfig *config = [PFConfig getConfig];

        if (config)
        {
         
            tempImageFile = config[@"BQDefaultUserImage"];
            
        }
        else
        {
            
            NSLog(@"error fetching Config!");
            tempImageFile = nil;
            
        }
    
    return tempImageFile;
    
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
    newAnswer.userName = self.username;
    newAnswer.answerText = answer;
    newAnswer.question = thisQuestion;
    newAnswer.votes = 0; //no votes yet
    
    if (self.userImage == nil) //if no user image, set the default
    {
        [self setDefaultProfileImage];
    }
    newAnswer.userImage = self.userImage;
    
    [newAnswer save];
    
    //associate the answer with this question, increment answer count, and save the question.
    [thisQuestion addObject:newAnswer forKey:@"answers"];
    [thisQuestion incrementKey:@"answerCount"];
    [thisQuestion save];
    
    NSNotification* notification = [NSNotification notificationWithName:@"BQDidPostNewAnswerToQuestion" object:thisQuestion];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//This user increments this answer's vote count.
- (void)likeAnswer:(BQAnswer *)answer
{
    answer.votes++;
}

@end
