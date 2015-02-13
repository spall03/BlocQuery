//
//  AppDelegate.m
//  BlocQuery
//
//  Created by Stephen Palley on 1/12/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "BQUser.h"
#import "BQLoginViewController.h"
#import "BQSignupViewController.h"
#import "BQQuestionTableViewController.h"

@interface AppDelegate () <PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //[Parse enableLocalDatastore];
    
    
    // Initialize Parse.
    [Parse setApplicationId:@"M1ZYcrIoDrykxD2p7GqRsCAHG280O9EMiOJi6MLH"
                  clientKey:@"BTu01nl3OsjWFKSFKLJDWp0sHHfkDbQApan7Fg9N"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptionsInBackground:launchOptions block:nil];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeUserDidLogOutNotification:) name:@"kBQUserDidLogout" object:nil];
    
    [self presentLoginScreen];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma Login Delegate

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    BQQuestionTableViewController *questionTableVC = [[BQQuestionTableViewController alloc] init];
    
    
    [(UINavigationController*)self.window.rootViewController setViewControllers:@[questionTableVC]];
}

#pragma Signup Delegate

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    [self.window.rootViewController dismissViewControllerAnimated:signUpController completion:nil];
    BQQuestionTableViewController *questionTableVC = [[BQQuestionTableViewController alloc] init];
    
    
    [(UINavigationController*)self.window.rootViewController setViewControllers:@[questionTableVC]];
    
}

- (void)activeUserDidLogOutNotification:(NSNotification*)notification
{
    
    [self presentLoginScreen];
    
}

- (void)presentLoginScreen
{
    
    BQLoginViewController *loginController = [[BQLoginViewController alloc] init];
    loginController.delegate = self;
    
    BQSignupViewController *signupController = [[BQSignupViewController alloc] init];
    [signupController setFields:PFSignUpFieldsDefault];
    [signupController setDelegate:self]; //not sure why it doesn't like this...?
    
    [loginController setSignUpController:signupController];
    
    UINavigationController *navVC = [[UINavigationController alloc] init];
    
    [navVC setViewControllers:@[loginController]];
    
    self.window.rootViewController = navVC;
    
    [self.window makeKeyAndVisible];
    
}


@end
