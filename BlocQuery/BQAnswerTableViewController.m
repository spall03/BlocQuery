//
//  BQAnswerTableViewController.m
//  BlocQuery
//
//  Created by Stephen Palley on 1/21/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import "BQAnswerTableViewController.h"
#import "BQAnswerQuestionView.h"
#import "PFTableViewCell.h"
#import <Parse/Parse.h>
#import "BQUser.h"
#import "BQProfileViewController.h"
#import "BQTableCellView.h"

@interface BQAnswerTableViewController () <BQAnswerQuestionViewDelegate, BQTableCellViewDelegate>

@property (nonatomic, strong) UIImage *placeholderImage;

@end

@implementation BQAnswerTableViewController

- (instancetype)initWithQuestion:(BQQuestion*)question
{
    self = [super init];
    if ( self )
    {
        self.question = question;
        //display the questioner in the title bar
        NSString *titleString = [NSString stringWithFormat:@"%@ asks:", self.question.userName]; // TODO: To avoid the awkward-looking "(null) asks" I might check for nil and substitute "A user", like so:
        //             NSString* username = ( !self.question.user ) ? @"A user": self.question.user;
        //             NSString *titleString = [NSString stringWithFormat:@"%@ asks:", username];
        [self setTitle:titleString];
        
        //enable a button to add a new answer to the question
        UIBarButtonItem *addAnswerButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didPressAddAnswerButton:)];
        [self.navigationItem setRightBarButtonItem:addAnswerButton ];
        
        BQAnswerQuestionView* answerView = [[BQAnswerQuestionView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 100) andQuestion:question];
        self.answerView = answerView;
        self.answerView.delegate = self;
        
        [self.view setBackgroundColor:[UIColor whiteColor]];

    }
    
    PFConfig *config = [PFConfig getConfig];
    PFFile *tempImageFile = config[@"BQDefaultUserImage"];
    NSData *tempImageData = [tempImageFile getData];
    self.placeholderImage = [UIImage imageWithData:tempImageData]; //placeholder image goes in no matter what b/c that's how PFImageView works
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"BQAnswer";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"answerText";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        self.imageKey = @"userImage";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}


 // Override to customize what kind of query to perform on the class. The default is to query for
 // all objects ordered by createdAt descending.
 - (PFQuery *)queryForTable
{
    //pull in answers to this particular question
    PFQuery *query = [PFQuery queryWithClassName:@"BQAnswer"];
    [query whereKey:@"question" equalTo:self.question];
    
     // If Pull To Refresh is enabled, query against the network by default.
     if (self.pullToRefreshEnabled) {
     query.cachePolicy = kPFCachePolicyNetworkOnly;
     }
     
     // If no objects are loaded in memory, we look to the cache first to fill the table
     // and then subsequently do a query against the network.
     if (self.objects.count == 0) {
     query.cachePolicy = kPFCachePolicyCacheThenNetwork;
     }
 
    [query orderByDescending:@"votes"];
 
 return query;
    
 }



//Customizes cells to show number of answers to questions
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *CellIdentifier = @"Cell";
    
    BQTableCellView *cell = (BQTableCellView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[BQTableCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    BQAnswer *temp = (BQAnswer *)object;
    PFFile *image = temp.userImage;
    NSString *userName = temp.userName;
    NSString *text = temp.answerText;
    NSString *secondaryText = [NSString stringWithFormat:@"Votes: %d", temp.votes];
    
    if ( cell == nil )
    {
        cell = [[BQTableCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure our cell... when we dequeue our cell we're left with the previous contents, if we re-use one,
    // so we need to always set up the cell...
    
    [cell setCellImage:image cellUserName:userName placeholderImage:self.placeholderImage cellText:text cellSecondaryText:secondaryText andVoteButton:YES];
    cell.delegate = self;
    
    NSString *voteButtonText;
    UIColor *voteButtonColor;
    
    if ([self checkVote:cell])
    {
        voteButtonText = @"Voted";
        voteButtonColor = [UIColor lightGrayColor];
    }
    else
    {
        voteButtonText = @"Vote";
        voteButtonColor = [UIColor whiteColor];
    }
    
    [cell.voteButton setTitle:voteButtonText forState:UIControlStateNormal];
    [cell.voteButton setBackgroundColor:voteButtonColor];

    return cell;
}


/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [self.objects objectAtIndex:indexPath.row];
 }
 */

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */

#pragma mark - UITableViewDataSource

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the object from Parse and reload the table view
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, and save it to Parse
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)didPressAddAnswerButton:(id)sender
{
   
   //cause our answerQuestionView to expand its text window...
    [self.answerView startTextEditing];
    
}

#pragma mark - UITableViewDelegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
//    
//    //locate answer tapped
//    BQAnswer *temp = [self.objects objectAtIndex:indexPath.row];
//    
//    if (temp.userName != nil)
//    {
//        //build query for the user who wrote that answer
//        PFQuery *tempQuery = [BQUser query];
//        [tempQuery whereKey:@"username" equalTo:temp.userName];
//        
//        //load query into temporary user
//        BQUser *tempUser = [tempQuery findObjects][0];
//        
//        //create new profile screen for that user
//        BQProfileViewController *newProfileVC = [[BQProfileViewController alloc]initWithUser:tempUser];
//        
//        //go to that screen
//        [self.navigationController pushViewController:newProfileVC animated:YES];
//    }
//    else
//    {
//        
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Temporary User" message:@"You selected an answer from a temporary user! Please choose another answer." preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
//        
//        [alert addAction:defaultAction];
//        [self presentViewController:alert animated:YES completion:nil];
//        
//    }
//}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 300.0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.answerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.answerView.bounds.size.height;
}

#pragma BQTableCellViewDelegate

- (void) tableCellViewDidPressProfilePicture:(BQTableCellView *)sender
{
    
    NSLog(@"profile view pressed!");
    
    //create new profile screen for that user
    BQProfileViewController *newProfileVC = [[BQProfileViewController alloc]initWithUser:[sender getUser]];

    //go to that screen
    [self.navigationController pushViewController:newProfileVC animated:YES];
    
}

- (BOOL) checkVote:(BQTableCellView *)cell
{
    BQUser *votingUser = [BQUser currentUser];
    BQAnswer *answer = [cell getAnswer];
    
    [votingUser save];
    [answer save];
    
    BOOL found = NO;
    
    for (BQUser *t in answer[@"votingUsers"])
    {
        
        if ([t.objectId isEqualToString:votingUser.objectId])
        {
            found = YES;
        }
        
    }
    
    return found;
    
}

- (void) tableCellViewDidPressVoteButton:(BQTableCellView *)sender
{
    
    BQUser *votingUser = [BQUser currentUser];
    BQAnswer *answer = [sender getAnswer];
    
    [votingUser save];
    [answer save];
    
    if ([self checkVote:sender])
    {
        [answer removeObject:votingUser forKey:@"votingUsers"];
        [answer incrementKey:@"votes" byAmount:[NSNumber numberWithInt:-1]]; //decrement vote count
    }
    else
    {
        [answer addUniqueObject:votingUser forKey:@"votingUsers"];
        [answer incrementKey:@"votes"];
    }
    
    
    [answer save];
    
//    [sender changeVoteButtonText];
    [self loadObjects];
    
}

#pragma BQAnswerQuestionViewDelegate

//reload query table when the user adds a new answer to a question
- (void)answerQuestionViewDidAddAnswer:(BQAnswerQuestionView *)sender withAnswer:(NSString *)answerText
{
    
    //invoke user method for adding new answers to questions
    [[BQUser currentUser] addNewAnswer:answerText toQuestion:self.question];
    
    [self loadObjects];
}

- (void)didBeginAddingAnswer:(BQAnswerQuestionView*)sender
{
    [self.tableView reloadData];
}

@end
