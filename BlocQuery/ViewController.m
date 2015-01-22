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
    BQLoginViewController *loginController = [[BQLoginViewController alloc] init];
    loginController.delegate = self;
    
    BQSignupViewController *signupController = [[BQSignupViewController alloc] init];
    [signupController setFields:PFSignUpFieldsDefault | PFSignUpFieldsAdditional];
    [signupController setDelegate:self]; //not sure why it doesn't like this...?
    
    [loginController setSignUpController:signupController];
    
    BQQuestionTableViewController *questionTableVC = [[BQQuestionTableViewController alloc] init];
    
    BQAnswerContainerViewController *answerContainerVC = [[BQAnswerContainerViewController alloc]init];
    
    BQUser *new = [[BQUser alloc]init];
    new.username = @"John Kennedy";
    new.password = @"password";
    [new signUp];
    
    BQQuestion *q = [new addNewQuestion:@"Why is the sky blue?"];
    [q save];
    [new addNewAnswer:@"Because that's just the way it is." toQuestion:q];
    [new addNewAnswer:@"Because the ocean is blue." toQuestion:q];
    [new addNewAnswer:@"Stop asking stupid questions." toQuestion:q];
    
    
    BQAnswerTableViewController *answerTableVC = [[BQAnswerTableViewController alloc] init];
    answerTableVC.question = q;
    
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:answerTableVC];
    
    
    [self presentViewController:navVC animated:NO completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// TODO: For us to push the new table view controller onto the stack after login we'll need to implement things like:
// - (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user;
// and
// - (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user

@end
