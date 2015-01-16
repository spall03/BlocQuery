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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    ***Test code for Account Creation
    
//    UIImage *myImage = [[UIImage alloc]initWithContentsOfFile:@"/Users/spall/Desktop/Bloc/iOS/BlocQuery/BlocQuery/seal.png"];
//    NSData *myData = UIImagePNGRepresentation(myImage);
//    PFFile *myFile = [PFFile fileWithData:myData];
//    
//    BQUser *testUser = [BQUser object];
//    testUser.userDescription = @"this is a test description!";
//    testUser.userImage = myFile;
//    testUser.username = @"Tester Extraordinaire";
//    testUser.password = @"password";
//    [testUser signUpInBackground];
    
//    **Test code for Question Creation
    
//    BQQuestion *testQ = [BQQuestion object];
//    testQ.questionText = @"This is a test question.";
//    [testQ saveInBackground];
    
//    **Test code for Answer Creation
    
//    BQAnswer *testA = [BQAnswer object];
//    testA.answerText = @"This is a test answer.";
//    testA.votes = 10;
//    [testA saveInBackground];

//    **Test code for User methods to create and answer questions, and to vote for answers
    
//    BQUser *test1 = [BQUser object];
//    test1.username = @"Theodore Roosevelt";
//    test1.password = @"password";
//    test1.userDescription = @"yada yada yada";
//    [test1 signUpInBackground];
//    
//    BQQuestion *q1 = [test1 addNewQuestion:@"What the hell is going on here?"];
//    [q1 save];
//    BQAnswer *a1 = [test1 addNewAnswer:@"We're testing a bunch of stuff." toQuestion:q1];
//    [a1 save];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    BQLoginViewController *loginController = [[BQLoginViewController alloc] init];
    loginController.delegate = self;
    
    BQSignupViewController *signupController = [[BQSignupViewController alloc] init];
    [signupController setFields:PFSignUpFieldsDefault | PFSignUpFieldsAdditional];
    [signupController setDelegate:self]; //not sure why it doesn't like this...?
    
    [loginController setSignUpController:signupController];
    
    [self presentViewController:loginController animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
