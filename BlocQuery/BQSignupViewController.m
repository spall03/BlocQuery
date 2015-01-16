//
//  BQSignupViewController.m
//  BlocQuery
//
//  Created by Stephen Palley on 1/14/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import "BQSignupViewController.h"

@interface BQSignupViewController ()

@end

@implementation BQSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *logoImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"signup" ofType:@".png"]];
    UIImageView *signupLogo = [[UIImageView alloc] initWithImage:logoImage];
    
    //enable user description field at signup
    [self.signUpView.additionalField setPlaceholder:@"Describe yourself"];
    
    //customize logo
    [self.signUpView setLogo:signupLogo];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end