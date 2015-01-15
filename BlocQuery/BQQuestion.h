//
//  BQQuestion.h
//  BlocQuery
//
//  Created by Stephen Palley on 1/15/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import <Parse/Parse.h>
#import "BQUser.h"

@interface BQQuestion : PFObject<PFSubclassing>

@property (retain) BQUser *user;
@property (retain) NSString *questionText;
@property (retain) NSArray *answers;
@property int answerCount;

 + (NSString *)parseClassName;

@end
