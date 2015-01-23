//
//  BQAnswer.m
//  BlocQuery
//
//  Created by Stephen Palley on 1/15/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>
#import "BQAnswer.h"

@interface BQAnswer ()

@end

@implementation BQAnswer

@dynamic user;
@dynamic question;
@dynamic answerText;
@dynamic votes;

+ (void)load {
    
    [self registerSubclass];
    
}

+ (NSString *) parseClassName
{
    
    return @"BQAnswer";
    
}

@end
