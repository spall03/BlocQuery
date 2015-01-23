//
//  BQQuestion.h
//  BlocQuery
//
//  Created by Stephen Palley on 1/15/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import <Parse/Parse.h>

@class BQUser;

@interface BQQuestion : PFObject<PFSubclassing>

@property (retain) NSString *user;
@property (retain) NSString *questionText;
@property (retain) NSArray *answers;
@property int answerCount;

 + (NSString *)parseClassName;

@end
