//
//  BQProfileViewController.h
//  BlocQuery
//
//  Created by Stephen Palley on 2/3/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BQUser;

@interface BQProfileViewController : UIViewController

- (instancetype)initWithUser:(BQUser*)user;

@end
