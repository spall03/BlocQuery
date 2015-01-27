//
//  BQAnswerTableViewController.h
//  BlocQuery
//
//  Created by Stephen Palley on 1/21/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import "PFQueryTableViewController.h"
#import "BQQuestion.h"

@interface BQAnswerTableViewController : PFQueryTableViewController

@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) BQQuestion *question; //the question we're going to pull answers in for

- (instancetype)initWithQuestion:(BQQuestion*)question;
@end
