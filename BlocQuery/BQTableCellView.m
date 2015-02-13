//
//  BQTableCellView.m
//  BlocQuery
//
//  Created by Stephen Palley on 2/13/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import "BQTableCellView.h"


@interface BQTableCellView ()

@property (nonatomic, strong) PFImageView *cellImage;
@property (nonatomic, strong) UILabel *cellText;
@property (nonatomic, strong) UIButton *voteButton; //hidden for answer table view cells

@property (nonatomic, strong) UITapGestureRecognizer *tapImage;
@property (nonatomic, strong) UITapGestureRecognizer *tapText;

@end

@implementation BQTableCellView


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        
        self.cellImage = [[PFImageView alloc]init];
        self.cellText = [[UILabel alloc]init];
        self.voteButton = [UIButton buttonWithType:UIButtonTypeSystem];
        
        self.tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageFired:)];
        self.tapText = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTextFired:)];
        [self.voteButton addTarget:self action:@selector(voteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        self.tapImage.delegate = self;
        self.tapText.delegate = self;
        
        //set values
        [self.voteButton setTitle:@"Vote" forState:UIControlStateNormal];
        
        //set cell text to wrap
        self.cellText.numberOfLines = 0;
        self.cellText.lineBreakMode = NSLineBreakByWordWrapping;
        
        //make image and text label touchable and add the recognizers to them
        self.cellImage.userInteractionEnabled = YES;
        self.cellText.userInteractionEnabled = YES;
        [self.cellImage addGestureRecognizer:self.tapImage];
        [self.cellText addGestureRecognizer:self.tapText];
        
        //add subviews
        for (UIView *view in @[self.cellImage, self.cellText, self.voteButton]) {
            [self.contentView addSubview:view];
            view.translatesAutoresizingMaskIntoConstraints = NO;
        }
        
        //autolayout stuff
        NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_cellImage, _cellText, _voteButton);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cellImage][_cellText][_voteButton]|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewDictionary]];
        
    
        
    }
    
    
    return self;
}

- (void) setCellImage:(PFFile *)image cellText:(NSString *)text
{
    self.cellImage.file = image;
    self.cellText.text = text;
    
    [self.cellImage loadInBackground];
    
}


- (void)tapImageFired:(id)sender
{
    
    NSLog(@"Image was tapped!");
    
}

- (void)tapTextFired:(id)sender
{
    
    NSLog(@"Text was tapped!");
    
}

- (void)voteButtonPressed:(id)sender
{
    
    
    NSLog(@"Button was tapped!");
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
