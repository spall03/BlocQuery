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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //display the questioner in the title bar
    NSString *titleString = [NSString stringWithFormat:@"%@ asks:", _question.user];
    [self setTitle:titleString];
    
    //enable a button to add a new answer to the question
    UIBarButtonItem *addAnswerButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
    [self.navigationItem setRightBarButtonItem:addAnswerButton];
    
    //display the question text first
    NSString *questionString = [NSString stringWithFormat:@"%@", _question.questionText];
    CGRect labelFrame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, 150); //TODO: the y-offset to get the label underneath the nav bar shouldn't be hard-coded like this
    self.questionLabel = [[UILabel alloc]initWithFrame:labelFrame];
    self.questionLabel.text = questionString;
    self.questionLabel.textAlignment = NSTextAlignmentCenter;
    
    //then display the table of answers underneath it
    self.answerTable = [[BQAnswerTableViewController alloc] init];
    self.answerTable.question = _question;
    
    UIView *answerTable = self.answerTable.view;
    UILabel *titleLabel = self.questionLabel;
    

    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self addChildViewController:self.answerTable];
    [self.view addSubview:answerTable];
    [self.view addSubview:titleLabel];
    
    //FIXME: This autolayout stuff doesn't work.
    
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(answerTable, titleLabel);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel]-100-[answerTable]" options:kNilOptions metrics:nil views:viewDictionary]];

    
    
    
}

- (void)viewDidLayoutSubviews
{

    
    
    
    
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
