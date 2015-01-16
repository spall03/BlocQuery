//
//  BQUser.h
//  BlocQuery
//
//  Created by Stephen Palley on 1/13/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import <Parse/Parse.h>
#import "BQQuestion.h"
#import "BQAnswer.h"

//@class BQQuestion;
//@class BQAnswer;


@interface BQUser : PFUser<PFSubclassing>

@property (retain) NSString *userDescription;
@property (retain) PFFile *userImage;

- (BQQuestion *) addNewQuestion:(NSString *) question;
- (BQAnswer *) addNewAnswer:(NSString *) answer toQuestion:(BQQuestion *) question;
- (void) likeAnswer: (BQAnswer *) answer;

@end
