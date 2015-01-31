//
//  BQAddQuestionViewController.m
//  BlocQuery
//
//  Created by Stephen Palley on 1/30/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import "BQAddQuestionViewController.h"
#import "BQAddQuestionView.h"

@interface BQAddQuestionViewController () <BQAddQuestionViewDelegate>


@end

@implementation BQAddQuestionViewController

- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        CGRect newFrame = self.view.frame;
        newFrame.size.width = newFrame.size.width * 0.8;
        newFrame.size.height = newFrame.size.height * 0.8;
        
        BQAddQuestionView *newAddQuestionView = [[BQAddQuestionView alloc] initWithFrame:newFrame];
        newAddQuestionView.delegate = self;
        
        self.view = newAddQuestionView;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma AddQuestionViewDelegate

//just for passing signal through to BQQuestionTableViewController
- (void)addQuestionViewDidAddQuestion:(BQAddQuestionView *)sender
{
    

    NSLog(@"Question submitted by view!");
    [self.delegate addQuestionVCDidAddQuestion:self];
    
}

//just for passing signal through to BQQuestionTableViewController
- (void)addQuestionViewWasCanceled:(BQAddQuestionView *)sender
{
    
    NSLog(@"Question canceled by view!");
    [self.delegate addQuestionVCDidCancel:self];
    
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
