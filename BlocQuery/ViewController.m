//
//  ViewController.m
//  BlocQuery
//
//  Created by Stephen Palley on 1/12/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import "BQUser.h"
#import "BQQuestion.h"
#import "BQAnswer.h"
#import "BQLoginViewController.h"
#import "BQSignupViewController.h"
#import "BQQuestionTableViewController.h"
#import "BQAnswerContainerViewController.h"
#import "BQAnswerTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
//
//    BQQuestionTableViewController *questionTableVC = [[BQQuestionTableViewController alloc]init];
//    
//    BQAnswerContainerViewController *answerContainerVC = [[BQAnswerContainerViewController alloc]init];
//    PFQuery *userQuery = [BQUser query];
//    BQUser *tester = (BQUser*)[userQuery getObjectWithId:@"sdAHrhGCel"];
//    
//    NSLog(@"%@", tester.username);
//    
//    BQQuestion *q = [tester addNewQuestion:@"Why is the sky blue?"];
//    [q save];
//    BQAnswer *a = [tester addNewAnswer:@"Because I said so." toQuestion:q];
//    [a save];
//    [tester addNewAnswer:@"Because the ocean is blue." toQuestion:q];
//    [tester addNewAnswer:@"Stop asking stupid questions." toQuestion:q];
    
    
//    BQAnswerTableViewController *answerTableVC = [[BQAnswerTableViewController alloc] init];
//    answerTableVC.question = q;
//    
//    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:loginController];
////
////    
//    [self :navVC animated:NO completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
