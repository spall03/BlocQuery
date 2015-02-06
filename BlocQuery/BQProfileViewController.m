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
//@property (nonatomic, strong) PFFile *userImage;
//@property (nonatomic, strong) NSString *userDescription;
@property (nonatomic, strong) NSString *placeholderDescription;
@property BOOL isCurrentUser;

@property (nonatomic, strong) PFImageView *userImageView;
@property (nonatomic, strong) UIImage *placeholderImage;
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
    
    //load up the config file to get default values
    PFConfig *config = [PFConfig getConfig];
    PFFile *tempImageFile = config[@"BQDefaultUserImage"];
    NSData *tempImageData = [tempImageFile getData];
    self.placeholderImage = [UIImage imageWithData:tempImageData]; //placeholder image goes in no matter what b/c that's how PFImageView works
    self.placeholderDescription = config[@"BQDefaultUserDescription"];
    
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
    
    
    //try to load the user's info from the cloud
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
                 NSLog(@"User description exists");
                 self.userDescriptionTextView.text = temp[@"additional"];
             }
             

             else
             {
                 NSLog(@"No user description!");
                 self.userDescriptionTextView.text = self.placeholderDescription;
             }
             
             //do the same thing for the user image
             if (temp[@"userImage"])
             {
                 NSLog(@"User image exists!");
                 self.userImageView.file = temp[@"userImage"];
                [self.userImageView loadInBackground]; //??? will this redraw the view again once it loads?
             }
             
             else
             {
                 NSLog(@"No user image!");
             }
             
             //this will display all the user data we got from the cloud
             [self.view layoutSubviews];
             
         }
         
         else
         {
             NSLog(@"Error contacting the cloud: %@", error);
         }
         
     }];
    
    
}

//set up with placeholders because the real stuff is coming asynchronously
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat: @"%@'s User Profile", self.user.username];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.userDescriptionTextView = [[UITextView alloc]init];
    self.userDescriptionTextView.text = @"Loading...";
    
    //set the user image's default and actual values, then pull actual from cloud
    self.userImageView = [[PFImageView alloc]init];
    self.userImageView.image = self.placeholderImage;


    [self.view addSubview:self.userDescriptionTextView];
    [self.view addSubview:self.userImageView];
    
    //enable editing buttons if you're looking at your own profile
    if (self.isCurrentUser)
    {
        self.editUserImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.editUserImageButton setTitle:@"Change Photo" forState:UIControlStateNormal];
        [self.editUserImageButton addTarget:self action:@selector(editImageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        self.editUserDescriptionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.editUserDescriptionButton setTitle:@"Edit Description" forState:UIControlStateNormal];
        [self.editUserDescriptionButton addTarget:self action:@selector(editDescriptionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.editUserImageButton];
        [self.view addSubview:self.editUserDescriptionButton];
    }

}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    //set text field's frame and reveal it
    self.userDescriptionTextView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 200);
    self.userDescriptionTextView.backgroundColor = [UIColor lightGrayColor];
    self.userDescriptionTextView.hidden = NO;
    self.userDescriptionTextView.userInteractionEnabled = NO; //need to hit edit button first
    
    self.userImageView.frame = CGRectMake(0, 200, self.view.bounds.size.width, 200);
    
    if (self.isCurrentUser)
    {
    
        self.editUserImageButton.frame = CGRectMake(100, 400, 100, 100);
        self.editUserDescriptionButton.frame = CGRectMake(100, 500, 100, 100);
        
        [self.editUserImageButton sizeToFit];
        [self.editUserDescriptionButton sizeToFit];
    
    }
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma button handling

-(void) editImageButtonPressed:(id)sender
{
    
    NSLog(@"Edit image pressed!");
    
    
}

-(void) editDescriptionButtonPressed:(id)sender
{
    
    NSLog(@"Edit description pressed!");
    
    
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
