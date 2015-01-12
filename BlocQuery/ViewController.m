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

@interface ViewController () <PFLogInViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];
    
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    PFLogInViewController *loginController =[[PFLogInViewController alloc]init];
    loginController.delegate = self;
    [self presentViewController:loginController animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
