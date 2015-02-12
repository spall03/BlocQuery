//
//  BQQuestion.h
//  BlocQuery
//
//  Created by Stephen Palley on 1/15/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import <Parse/Parse.h>
#import "BQAnswer.h"

@class BQUser;


@interface BQQuestion : PFObject<PFSubclassing>

@property (retain) PFFile *userImage;
@property (retain) NSString *userName;
@property (retain) NSString *questionText;
@property (retain) NSArray *answers;
@property int answerCount; // TODO: Why the answersCount property? Why not just use self.answers.count?

+ (NSString *)parseClassName;

@end
