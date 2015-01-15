//
//  BQUser.h
//  BlocQuery
//
//  Created by Stephen Palley on 1/13/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import <Parse/Parse.h>

@interface BQUser : PFUser<PFSubclassing>

@property (retain) NSString *userDescription;
@property (retain) PFFile *userImage;

@end
