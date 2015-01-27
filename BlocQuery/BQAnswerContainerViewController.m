//
//  BQAnswerContainerViewController.m
//  BlocQuery
//
//  Created by Stephen Palley on 1/21/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import "BQAnswerContainerViewController.h"
#import "BQAnswerTableViewController.h"

@interface BQAnswerContainerViewController ()

@end

@implementation BQAnswerContainerViewController

- (instancetype)initWithQuestion:(BQQuestion*)question
{
    self = [super init];
    if ( self )
    {
        self.question = question;
        //display the questioner in the title bar
        NSString *titleString = [NSString stringWithFormat:@"%@ asks:", self.question.user]; // TODO: To avoid the awkward-looking "(null) asks" I might check for nil and substitute "A user", like so:
        //             NSString* username = ( !self.question.user ) ? @"A user": self.question.user;
        //             NSString *titleString = [NSString stringWithFormat:@"%@ asks:", username];
        [self setTitle:titleString];
        
        //enable a button to add a new answer to the question
        UIBarButtonItem *addAnswerButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
        [self.navigationItem setRightBarButtonItem:addAnswerButton];
        
        //display the question text first
        NSString *questionString = [NSString stringWithFormat:@"%@", self.question.questionText];
        self.questionLabel = [[UILabel alloc] init];
        self.questionLabel.text = questionString;
        self.questionLabel.textAlignment = NSTextAlignmentCenter;
        
        //then display the table of answers underneath it
        self.answerTable = [[BQAnswerTableViewController alloc] initWithQuestion:self.question];
        
        UIView *answerTableView = self.answerTable.view;
        
        [self.view setBackgroundColor:[UIColor whiteColor]];
        [self addChildViewController:self.answerTable];
        [self.view addSubview:answerTableView];
        [self.view addSubview:self.questionLabel];
        
        // FIXME: The layout still isn't quite right, partially because we're mixing view controllers and views, here.
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        CGRect labelFrame = CGRectMake(0.0f, ( self.presentingViewController.navigationController.navigationBar.frame.size.height + 10 ), self.view.frame.size.width, self.view.frame.size.height);
    self.questionLabel.frame = labelFrame;
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
