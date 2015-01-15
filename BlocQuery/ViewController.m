//
//  ViewController.m
//  BlocQuery
//
//  Created by Stephen Palley on 1/12/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import "ParseUI.h"
#import "BQUser.h"
#import "BQLoginViewController.h"
#import "BQSignupViewController.h"

@interface ViewController () <PFLogInViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    BQLoginViewController *loginController =[[BQLoginViewController alloc]init];
    loginController.delegate = self;
    
    BQSignupViewController *signupController = [[BQSignupViewController alloc]init];
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
