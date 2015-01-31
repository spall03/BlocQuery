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
#import "BQAddQuestionViewController.h"
#import "BQAddQuestionView.h"
#import <Parse/Parse.h>

@interface BQQuestionTableViewController () <BQAddQuestionViewControllerDelegate>

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
        // self.imageKey = @"image";
        
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
    UIBarButtonItem *profileButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:nil action:nil];
    [self.navigationItem setLeftBarButtonItem:profileButton];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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


//Customizes cells to show number of answers to questions
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
     static NSString *CellIdentifier = @"Cell";
     
     PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
     if ( cell == nil )
     {
         cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
     }
    
    
     // Configure the cell to show question text and number of answers to question
     cell.textLabel.text = [object objectForKey:self.textKey];
     cell.detailTextLabel.text = [NSString stringWithFormat:@"Answers: %@",
                                 object[@"answerCount"]];
    
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
    
//    CGRect modalWindow = CGRectMake( [UIScreen mainScreen].bounds.origin.x, [UIScreen mainScreen].bounds.origin.y, 200, 200);
    
    UIWindow *questionModal = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    questionModal.backgroundColor = [UIColor grayColor];
    
    
    BQAddQuestionViewController *addQuestionVC = [[BQAddQuestionViewController alloc]init];
    addQuestionVC.delegate = self;
    
    
    [questionModal setRootViewController:addQuestionVC];
    questionModal.windowLevel = UIWindowLevelAlert;
    
    self.modalWindow = questionModal;
    self.modalWindow.hidden = NO;
    
}

#pragma AddQuestionVCDelegate

//hides question submission window and reloads question table
- (void)addQuestionVCDidAddQuestion:(BQAddQuestionView *)sender
{
    
    self.modalWindow.hidden = YES;
    [self loadObjects];
    
}

//just hides question submission window without reloading
- (void)addQuestionVCDidCancel:(BQAddQuestionView *)sender
{
    
    self.modalWindow.hidden = YES;
    
}


@end
