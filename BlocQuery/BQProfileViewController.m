//
//  BQProfileViewController.m
//  BlocQuery
//
//  Created by Stephen Palley on 2/3/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import "BQProfileViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "BQUser.h"


@interface BQProfileViewController ()

@property (nonatomic, strong) BQUser *user;
@property (nonatomic, strong) PFImageView *userImage;
@property (nonatomic, strong) NSString *userDescription;
@property BOOL isCurrentUser;

@property (nonatomic, strong) UITextView *userDescriptionTextView;
@property (nonatomic, strong) UIButton *editUserImageButton;
@property (nonatomic, strong) UIButton *editUserDescriptionButton;

@end

@implementation BQProfileViewController

- (instancetype)initWithUser:(BQUser*)user
{
    self = [super init];
    
    if (self)
    {
        self.user = user;
    }
    
    [self determineUser];
    [self loadData];
    
    return self;
}

//determine whether this profile belongs to the current user. This will be used to show / hide editing buttons
- (void) determineUser
{
    if (self.user == [BQUser currentUser])
    {
        self.isCurrentUser = true;
    }
    else
    {
        self.isCurrentUser = false;
    }
}

//attempt to load user data from cloud. if no user data, load defaults from config
- (void) loadData
{
    //first, try to load up the user's info from the cloud
    PFQuery *userQuery = [PFUser query];
    [userQuery whereKey:@"username" equalTo:self.user.username];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         
         if (!error)
         {
             NSLog(@"Cloud has been queried!");
             
             BQUser *temp = objects[0];
             
             //if it works and user already has a description, load that description into the textview
             if (![temp[@"additional"] isEqual: @""])
             {
                 NSLog(@"User data exists");
                 self.userDescription = temp[@"additional"];
                 self.userDescriptionTextView.text = self.userDescription;
             }
             
             //if no user data, grab description from config
             else
             {
                 NSLog(@"No user data!");
                 
                 [PFConfig getConfigInBackgroundWithBlock:^(PFConfig *config, NSError *error) {
                     if (config)
                     {
                         NSLog(@"Config fetched!");
                         
                         self.userDescription = config[@"BQDefaultUserDescription"];
                         self.userDescriptionTextView.text = self.userDescription;
                     }
                     else
                     {
                         NSLog(@"Defaults didn't load, and here's why: %@", error);
                     }
                 }];
                 
             }
             
         }
         
         else
         {
             NSLog(@"Error contacting the cloud: %@", error);
         }
         
     }];
    
    //refresh user image from cloud
    //   [self.userImage loadInBackground];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat: @"%@'s User Profile", self.user.username];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.userDescriptionTextView = [[UITextView alloc]init];
    self.userImage = [[PFImageView alloc]init];
    self.editUserImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.editUserDescriptionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    PFConfig *config = [PFConfig getConfig];
    PFFile *temp = config[@"BQDefaultUserImage"];
    NSData *data = [temp getData];
    UIImage *image = [UIImage imageWithData:data];
    self.userImage.image = image;

    [self.view addSubview:self.userDescriptionTextView];
    [self.view addSubview:self.userImage];

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    //set text field's frame and reveal it
    self.userDescriptionTextView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 200);
    self.userDescriptionTextView.backgroundColor = [UIColor lightGrayColor];
    self.userDescriptionTextView.hidden = NO;
    
    self.userImage.frame = CGRectMake(0, 200, self.view.bounds.size.width, 200);
    
    
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
