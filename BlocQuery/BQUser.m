//
//  BQUser.m
//  BlocQuery
//
//  Created by Stephen Palley on 1/13/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import "BQUser.h"
#import <Parse/PFObject+Subclass.h>

@interface BQUser ()

@end

@implementation BQUser

@dynamic userDescription;
@dynamic userImage;

+ (void)load {
    
    [self registerSubclass];
    
}

@end
