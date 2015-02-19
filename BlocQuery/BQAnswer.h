//
//  BQAnswer.h
//  BlocQuery
//
//  Created by Stephen Palley on 1/15/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import <Parse/Parse.h>

@class BQUser;
@class BQQuestion;

@interface BQAnswer : PFObject<PFSubclassing>

@property (retain) BQUser *user; //deprecated
@property (retain) NSString *userName;
@property (retain) PFFile  *userImage;
@property (retain) BQQuestion *question;
@property (retain) NSString *answerText;
@property (retain) NSArray *votingUsers;
@property int votes;

+(NSString *)parseClassName;

@end
