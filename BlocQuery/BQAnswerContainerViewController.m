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
    
    NSString *titleString = [NSString stringWithFormat:@"%@ asks:", _question.user];
    [self setTitle:titleString];
    
    UIBarButtonItem *addAnswerButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
    [self.navigationItem setRightBarButtonItem:addAnswerButton];
    
    NSString *questionString = [NSString stringWithFormat:@"%@", _question.questionText];
    CGRect labelFrame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, 200); //TODO: the y-offset to get the label underneath the nav bar shouldn't be hard-coded like this
    self.questionLabel = [[UILabel alloc]initWithFrame:labelFrame];
    self.questionLabel.text = questionString;
    self.questionLabel.textAlignment = NSTextAlignmentCenter;
    
    self.answerTable = [[BQAnswerTableViewController alloc] init];
    self.answerTable.question = _question;
    
    [self.view addSubview:self.questionLabel];
    [self.view addSubview:self.answerTable];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    
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
