//
//  BQLoginViewController.m
//  BlocQuery
//
//  Created by Stephen Palley on 1/14/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import "BQLoginViewController.h"
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface BQLoginViewController ()

@end

@implementation BQLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *logoImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BQLogo" ofType:@"png"]];
    UIImageView *BQLogo = [[UIImageView alloc] initWithImage:logoImage];

    //set up our custom BQ logo
    [self.logInView setBackgroundColor:[UIColor whiteColor]];
    [self.logInView setLogo:BQLogo];
    
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
