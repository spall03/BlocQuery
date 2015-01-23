//
//  BQAnswerContainerViewController.h
//  BlocQuery
//
//  Created by Stephen Palley on 1/21/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BQQuestion.h"
#import "BQAnswerTableViewController.h"

@interface BQAnswerContainerViewController : UIViewController

@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) BQQuestion *question;
@property (nonatomic, strong) BQAnswerTableViewController *answerTable;


@end
