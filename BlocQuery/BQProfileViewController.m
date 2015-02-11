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
#import "BQImageLibraryCollectionViewController.h"
#import "BQLoginViewController.h"


@interface BQProfileViewController () <BQImageLibraryViewControllerDelegate>

@property (nonatomic, strong) BQUser *user;
@property (nonatomic, strong) NSString *placeholderDescription;

@property BOOL isCurrentUser;
@property BOOL userTextIsBeingEdited;

@property (nonatomic, strong) PFImageView *userImageView;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) UITextView *userDescriptionTextView;
@property (nonatomic, strong) UIButton *editUserImageButton;
@property (nonatomic, strong) UIButton *editUserDescriptionButton;

@property (nonatomic, strong) NSLayoutConstraint *leftConstraint;
@property (nonatomic, strong) NSLayoutConstraint *rightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *leftButtonConstraint;
@property (nonatomic, strong) NSLayoutConstraint *rightButtonConstraint;

@end

@implementation BQProfileViewController


- (instancetype)initWithUser:(BQUser*)user
{
    self = [super init];
    
    if (self)
    {
        self.user = user;
    }
    
    //load up the config file to get default image and text
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
    PFQuery *userQuery = [BQUser query];
    [userQuery whereKey:@"username" equalTo:self.user.username];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         
         if (!error)
         {
             NSLog(@"Cloud has been queried!");
             
             BQUser *temp = objects[0];
             
             //if it works and user already has a description, load that description into the textview
             if (![temp[@"userDescription"] isEqual: @""])
             {
                 NSLog(@"User description exists");
                 self.userDescriptionTextView.text = temp[@"userDescription"];
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
    self.userTextIsBeingEdited = NO;
    
    self.userDescriptionTextView = [[UITextView alloc]init];
    self.userDescriptionTextView.text = @"Loading...";
    
    //set the user image's default and actual values, then pull actual from cloud
    self.userImageView = [[PFImageView alloc]init];
    self.userImageView.image = self.placeholderImage;


    [self.view addSubview:self.userDescriptionTextView];
    self.userDescriptionTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.userImageView];
    self.userImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //make profile editing buttons and leave them hidden by default
    self.editUserImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.editUserImageButton setTitle:@"Change Photo" forState:UIControlStateNormal];
    [self.editUserImageButton addTarget:self action:@selector(editImageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.editUserImageButton.hidden = YES;
    
    self.editUserDescriptionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.editUserDescriptionButton setTitle:@"Edit Description" forState:UIControlStateNormal];
    [self.editUserDescriptionButton addTarget:self action:@selector(editDescriptionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.editUserDescriptionButton.hidden = YES;
    
    [self.view addSubview:self.editUserImageButton];
    self.editUserImageButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.editUserDescriptionButton];
    self.editUserDescriptionButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    //enable logout button if you're looking at your own profile
    if (self.isCurrentUser)
    {
        UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleDone target:self action:@selector(logoutButtonPressed:)];
        [self.navigationItem setRightBarButtonItem:logoutButton];
    }

}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    

    //set text field's frame and reveal it
    self.userDescriptionTextView.backgroundColor = [UIColor lightGrayColor];
    self.userDescriptionTextView.hidden = NO;


    //unhide editing buttons if you are looking at your own profile
    if (self.isCurrentUser)
    {
        self.editUserImageButton.hidden = NO;
        self.editUserDescriptionButton.hidden = NO;
    }
    
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_userImageView, _userDescriptionTextView, _editUserDescriptionButton, _editUserImageButton  );

    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_userImageView(==128)][_userDescriptionTextView]|" options:kNilOptions metrics:nil views:viewDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_editUserImageButton][_editUserDescriptionButton]|" options:kNilOptions metrics:nil views:viewDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=20)-[_userImageView(==128)]-[_editUserImageButton(==100)]-(>=20)-|" options:kNilOptions metrics:nil views:viewDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=20)-[_userDescriptionTextView(==128)]-[_editUserDescriptionButton(==100)]-(>=20)-|" options:kNilOptions metrics:nil views:viewDictionary]];
    
    self.leftConstraint = [NSLayoutConstraint constraintWithItem:self.userImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    self.rightConstraint = [NSLayoutConstraint constraintWithItem:self.userDescriptionTextView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    self.leftButtonConstraint = [NSLayoutConstraint constraintWithItem:self.editUserImageButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.userImageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    self.rightButtonConstraint = [NSLayoutConstraint constraintWithItem:self.editUserDescriptionButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.userDescriptionTextView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    [self.view addConstraints:@[self.leftConstraint, self.rightConstraint, self.leftButtonConstraint, self.rightButtonConstraint]];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma button handling

-(void) editImageButtonPressed:(id)sender
{
    
    NSLog(@"Edit image pressed!");
    BQImageLibraryCollectionViewController *libraryVC = [[BQImageLibraryCollectionViewController alloc]init];
    libraryVC.delegate = self;
    [self.navigationController pushViewController:libraryVC animated:YES];
    
}

//enable user interaction, switch button state and title, send description
-(void) editDescriptionButtonPressed:(id)sender
{
    
    if (!self.userTextIsBeingEdited)
    {
        NSLog(@"Edit description pressed!");
        self.userDescriptionTextView.text = @"";
        self.userDescriptionTextView.userInteractionEnabled = YES;
        [self.editUserDescriptionButton setTitle:@"Done Editing" forState:UIControlStateNormal];
        self.userTextIsBeingEdited = YES;
    }
    else
    {
        NSLog(@"Submit new description!");
        self.userDescriptionTextView.userInteractionEnabled = NO;
        [self.editUserDescriptionButton setTitle:@"Edit Description" forState:UIControlStateNormal];
        self.userTextIsBeingEdited = NO;
        
        //set new user description and save to cloud
        self.user.userDescription = self.userDescriptionTextView.text;
        [self.user saveInBackground];
        
    }

}

//log off current user and return to login screen
-(void) logoutButtonPressed:(id)sender
{
    [BQUser logOut];
    
//    BQUser *test = [BQUser currentUser];
//    NSLog(@"current user: %@", test);
    
    BQLoginViewController *loginVC = [[BQLoginViewController alloc]init];

//    UINavigationController *newNav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    
    [self.navigationController pushViewController:loginVC animated:YES]; //FIXME: This takes us back to the login screen, but can't seem to log back in with another user
}



#pragma BQImageLibraryCollectionViewController delegate

- (void) imageLibraryViewController:(BQImageLibraryCollectionViewController *) controller didCompleteWithImage:(UIImage *)image
{
    if (image == nil)
    {
        NSLog(@"cancel button pressed!");
        [self.navigationController popToViewController:self animated:YES];
    }
    
    else
    {
        
        NSLog(@"image selected: %@", image.description);
        [self.navigationController popToViewController:self animated:YES];
        
        //first, make the image the right size
        UIImage *resizedImage;
        
        CGSize newSize = CGSizeMake(128, 128);
        
        UIGraphicsBeginImageContext(newSize);
        [image drawInRect:CGRectMake(0, 0, 128, 128)];
        
        resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //second, make the image a PFFile
        NSData *tempData = UIImagePNGRepresentation(resizedImage);
        PFFile *newProfileImage = [PFFile fileWithData:tempData];
        
        //third, upload the new image to the cloud
        self.user.userImage = newProfileImage;
        [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if ( succeeded )
             {
                 //fourth, reset the user's image locally
                 self.userImageView.file = newProfileImage;
                 [self.userImageView loadInBackground];
             }
             else
             {
                 NSLog( @"Error: We could not save our new profile image. %@", error );
             }
         }];
        

    }
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
