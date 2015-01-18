//
//  BQQuestion.m
//  BlocQuery
//
//  Created by Stephen Palley on 1/15/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>
#import "BQQuestion.h"

@interface BQQuestion ()

@end

@implementation BQQuestion

@dynamic user;
@dynamic questionText;
@dynamic answers;
@dynamic answerCount;


+ (void)load
{
    
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"BQQuestion";
}

@end
