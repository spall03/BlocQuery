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
@property (nonatomic, strong) UILabel *cellUserName;
@property (nonatomic, strong) UILabel *cellText;
@property (nonatomic, strong) UILabel *cellSecondaryText;
@property (nonatomic, strong) UIButton *voteButton; //hidden for answer table view cells

@property (nonatomic, strong) UITapGestureRecognizer *tapImage;
@property (nonatomic, strong) UITapGestureRecognizer *tapText;

@end

@implementation BQTableCellView


+ (CGFloat)cellHeightForText:(NSString *)text width:(CGFloat)width
{

    UILabel *tempLabel = [UILabel new];
    tempLabel.text = text;
    
    // Make a cell
    BQTableCellView *layoutCell = [[BQTableCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"layoutCell"];
    [layoutCell setCellText:tempLabel];
    
    layoutCell.frame = CGRectMake(0, 0, width, CGRectGetHeight(layoutCell.frame));
    
    [layoutCell setNeedsLayout];
    [layoutCell layoutIfNeeded];
    
    // Get the actual height required for the media item in the cell
    return CGRectGetMaxY(layoutCell.contentView.frame);
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        
        self.cellImage = [[PFImageView alloc]init];
        self.cellUserName = [[UILabel alloc]init];
        self.cellText = [[UILabel alloc]init];
        self.cellSecondaryText = [[UILabel alloc]init];
        self.voteButton = [UIButton buttonWithType:UIButtonTypeSystem];
        
        self.tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageFired:)];
        self.tapText = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTextFired:)];
        [self.voteButton addTarget:self action:@selector(voteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        self.tapImage.delegate = self;
        self.tapText.delegate = self;
        
        [self.voteButton setTitle:@"Vote" forState:UIControlStateNormal];
        
        //set cell text to wrap
        self.cellText.numberOfLines = 0;
        self.cellText.lineBreakMode = NSLineBreakByWordWrapping;
        self.cellSecondaryText.numberOfLines = 0;
        self.cellSecondaryText.lineBreakMode = NSLineBreakByWordWrapping;
        
        //make image and text label touchable and add the recognizers to them
        self.cellImage.userInteractionEnabled = YES;
        self.cellText.userInteractionEnabled = YES;
        self.cellSecondaryText.userInteractionEnabled = YES;
        [self.cellImage addGestureRecognizer:self.tapImage];
        [self.cellText addGestureRecognizer:self.tapText];
        [self.cellSecondaryText addGestureRecognizer:self.tapText];
        
        //add subviews
        for (UIView *view in @[self.cellImage, self.cellUserName, self.cellText, self.cellSecondaryText, self.voteButton]) {
            [self.contentView addSubview:view];
            view.translatesAutoresizingMaskIntoConstraints = NO;
        }
        
        //autolayout stuff
        NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_cellImage, _cellUserName, _cellText, _cellSecondaryText, _voteButton);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_cellImage(==128)]-[_cellText]-[_voteButton]-|" options:NSLayoutFormatAlignAllTop metrics:nil views:viewDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_cellUserName]-[_cellSecondaryText]-|" options:NSLayoutFormatAlignAllTop metrics:nil views:viewDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_cellImage(==128)]-[_cellUserName]-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:viewDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_cellText]-[_cellSecondaryText]-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:viewDictionary]];
    
        
    }
    
    
    return self;
}

- (void) setCellImage:(PFFile *)image cellUserName:(NSString *)name placeholderImage:(UIImage *)placeholderImage cellText:(NSString *)text cellSecondaryText:(NSString *)secondaryText andVoteButton:(BOOL)button
{
    self.cellImage.file = image;
    self.cellImage.image = placeholderImage;
    [self.cellImage loadInBackground];
    
    self.cellUserName.text = name;
    self.cellText.text = text;
    self.cellSecondaryText.text = secondaryText;
    
    if (button == NO)
    {
        self.voteButton.hidden = YES;
    }
    

    
}


- (void)tapImageFired:(id)sender
{
    
    [self.delegate tableCellViewDidPressProfilePicture:self];
    NSLog(@"tap image fired!");
    
}

- (void)tapTextFired:(id)sender
{
    [self.delegate tableCellViewDidPressTextField:self];
    NSLog(@"Text was tapped!");
    
}

- (void)voteButtonPressed:(id)sender
{
    
    
    NSLog(@"Button was tapped!");
    
}

//these are ugly hacks, but they work....
- (BQUser *)getUser
{
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:self.cellUserName.text];
    NSArray *user = [query findObjects];
    
    return (BQUser *)user[0];
    
}

- (BQQuestion *)getQuestion
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"BQQuestion"];
    [query whereKey:@"questionText" equalTo:self.cellText.text];
    NSArray *question = [query findObjects];
    
    return (BQQuestion *)question[0];

}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
