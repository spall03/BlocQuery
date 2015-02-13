//
//  BQQuestionTableViewController.m
//  BlocQuery
//
//  Created by Stephen Palley on 1/20/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import "BQQuestionTableViewController.h"
#import "BQQuestion.h"
#import "BQUser.h"
#import "BQAnswerTableViewController.h"
#import "PFTableViewCell.h"
#import "BQAddQuestionView.h"
#import "BQProfileViewController.h"
#import <Parse/Parse.h>
#import "BQTableCellView.h"

@interface BQQuestionTableViewController () <BQAddQuestionViewDelegate>

@property (nonatomic, strong) BQUser *user;
@property (nonatomic, strong) UIWindow *modalWindow;

@end

@implementation BQQuestionTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if ( self )
    {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"BQQuestion";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"questionText";
        
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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.user = [BQUser currentUser];
    
    //add a welcome message for the user
    NSString *titleString = [NSString stringWithFormat:@"Questions"];
    [self setTitle:titleString];
    
    //enable a button for adding new questions
    UIBarButtonItem *addQuestionButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewQuestion:)];
    [self.navigationItem setRightBarButtonItem:addQuestionButton];
    
    //enable a button to go to the user's profile
    UIBarButtonItem *profileButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(goToProfile:)];
    [self.navigationItem setLeftBarButtonItem:profileButton];
    
    //listening for new answers to questions, in order to update the number of answers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNewAnswerToQuestion:) name:@"BQDidPostNewAnswerToQuestion" object:nil];
}

- (void) didReceiveNewAnswerToQuestion:(NSNotification*)notification
{
    NSLog(@"Did notice change to object: %@", notification.object);
    
    [self loadObjects];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad
{
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

- (void)objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}

/*
 // Override to customize what kind of query to perform on the class. The default is to query for
 // all objects ordered by createdAt descending.
 - (PFQuery *)queryForTable {
 PFQuery *query = [PFQuery queryWithClassName:self.className];
 
 // If Pull To Refresh is enabled, query against the network by default.
 if (self.pullToRefreshEnabled) {
 query.cachePolicy = kPFCachePolicyNetworkOnly;
 }
 
 // If no objects are loaded in memory, we look to the cache first to fill the table
 // and then subsequently do a query against the network.
 if (self.objects.count == 0) {
 query.cachePolicy = kPFCachePolicyCacheThenNetwork;
 }
 
 [query orderByDescending:@"createdAt"];
 
 return query;
 }
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    
     static NSString *CellIdentifier = @"Cell";

     BQTableCellView *cell = (BQTableCellView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    BQQuestion *temp = (BQQuestion *)object;
    PFFile *image = temp.userImage;
    NSString *text = temp.questionText;

     if ( cell == nil )
     {
         cell = [[BQTableCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
         [cell setCellImage:image cellText:text];
     }
    
    
    return cell;
    
}


//Customizes cells to show number of answers to questions
// - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
//{
//     static NSString *CellIdentifier = @"Cell";
//     
//     PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//     if ( cell == nil )
//     {
//         cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//     }
//    
//    
//     // Configure the cell to show question text and number of answers to question
////     cell.textLabel.text = [object objectForKey:self.textKey];
////     cell.detailTextLabel.text = [NSString stringWithFormat:@"Answers: %@",
////                                 object[@"answerCount"]];
//    
//    // Configure the cell to show user who asked the question, the question's text, and number of answers to question
//    NSString *textLabelText = [NSString stringWithFormat:@"%@ asks: %@", object[@"userName"], object[@"questionText"]];
//    
//    cell.textLabel.text = textLabelText;
//    
//    NSArray *tempArray = object[@"answers"];
//    int answerCount = tempArray.count;
//    
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"Answers: %ld", (long)answerCount];
//    
//    cell.imageView.file = object[@"userImage"];
//    
//    
//     return cell;
// }


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

#pragma mark - UITableViewDelegate

//open up a table of answers when a question is selected by the user.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    //get the question the user tapped
    BQQuestion *answerviewQuestion = (BQQuestion*)[self objectAtIndexPath:indexPath];
    
    //create a new answerview container
    BQAnswerTableViewController *answerViewContainer = [[BQAnswerTableViewController alloc] initWithQuestion:answerviewQuestion];
    
    //and push it onto the stack
    [self.navigationController pushViewController:answerViewContainer animated:YES];
    
    
}

#pragma - adding new questions

- (void) addNewQuestion:(id)sender
{
    
    NSLog(@"add a new question!");
    

    
    UIWindow *questionModal = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    questionModal.backgroundColor = [UIColor clearColor];
    
    // FIXME: Handle device rotation
    questionModal.windowLevel = UIWindowLevelAlert;
    
    CGRect newFrame = questionModal.frame;
    newFrame.size.width = newFrame.size.width * 0.8;
    newFrame.size.height = newFrame.size.height * 0.6;
    // And center the view:
    newFrame.origin.x = ( ( questionModal.frame.size.width / 2 ) - ( newFrame.size.width / 2 ) );
    newFrame.origin.y = ( ( questionModal.frame.size.height / 2 ) - ( newFrame.size.height / 2 ) );

    BQAddQuestionView *newAddQuestionView = [[BQAddQuestionView alloc] initWithFrame:newFrame];
    newAddQuestionView.delegate = self;
    [newAddQuestionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];

    [questionModal addSubview:newAddQuestionView];
    
    self.modalWindow = questionModal;
    self.modalWindow.hidden = NO;
    
}

#pragma - going to profile view

- (void) goToProfile:(id)sender
{
    
    BQProfileViewController *profileViewController = [[BQProfileViewController alloc]initWithUser:[BQUser currentUser]]; //the profile button always takes you to YOUR profile
    
    [self.navigationController pushViewController:profileViewController animated:YES];
    
    
}

#pragma AddQuestionViewDelegate

//hides question submission window and reloads question table
- (void)addQuestionViewDidAddQuestion:(BQAddQuestionView *)sender withQuestionText:(NSString *)question
{
    NSLog(@"Question submitted by view!");
    self.modalWindow.hidden = YES;
    [[BQUser currentUser] addNewQuestion:question];
    [self loadObjects];
    
}

//just hides question submission window without reloading
- (void)addQuestionViewWasCanceled:(BQAddQuestionView *)sender
{
    
    NSLog(@"Question canceled by view!");
    self.modalWindow.hidden = YES;
    
}

@end

