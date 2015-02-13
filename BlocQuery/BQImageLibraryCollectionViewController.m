//
//  BQImageLibraryCollectionViewController.m
//  BlocQuery
//
//  Created by Stephen Palley on 2/9/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import "BQImageLibraryCollectionViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface BQImageLibraryCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) ALAssetsLibrary *library;

@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) NSMutableArray *arraysOfAssets;

@end

@implementation BQImageLibraryCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype) init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 100);
    
    self = [super initWithCollectionViewLayout:layout];
    
    if (self) {
        self.library = [[ALAssetsLibrary alloc] init];
        self.groups = [NSMutableArray array];
        self.arraysOfAssets = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusable view"];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    //add cancel button
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
    
    self.navigationItem.rightBarButtonItem = cancelButton;
}

//this fits maximum number of thumbnails based on device size
- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat minWidth = 100;
    NSInteger divisor = width / minWidth;
    CGFloat cellSize = width / divisor;
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(cellSize, cellSize);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.headerReferenceSize = CGSizeMake(width, 30);
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //clear out arrays
    [self.groups removeAllObjects];
    [self.arraysOfAssets removeAllObjects];
    
    [self.library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos | ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) { //nested blocks to populate asset arrays
        if (group) {
            [self.groups addObject:group];
            NSMutableArray *assets = [NSMutableArray array];
            [self.arraysOfAssets addObject:assets];
            
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    [assets addObject:result];
                }
            }];
            
            [self.collectionView reloadData];
        }
    } failureBlock:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK button") otherButtonTitles:nil];
        [alert show];
        
        [self.collectionView reloadData];
    }];
}

//clear arrays out of memory when scrolled off of screen
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.groups removeAllObjects];
    [self.arraysOfAssets removeAllObjects];
    [self.collectionView reloadData];
}

//delegate method for implementing class
- (void) cancelPressed:(UIBarButtonItem *)sender {
    [self.delegate imageLibraryViewController:self didCompleteWithImage:nil];
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

#pragma mark <UICollectionViewDataSource>

//return number of albums
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.groups.count;
}

//return number of items in an album
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *imagesArray = self.arraysOfAssets[section];
    
    if (imagesArray) {
        return imagesArray.count;
    }
    
    return 0;
}

//how to display individual cells in the gridded collection view
- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSInteger imageViewTag = 54321;
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:imageViewTag];
    
    //generate view to hold thumbnail
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
        imageView.tag = imageViewTag;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [cell.contentView addSubview:imageView];
    }
    
    ALAsset *asset = self.arraysOfAssets[indexPath.section][indexPath.row];
    CGImageRef imageRef = asset.thumbnail; //grab thumbnail picture
    
    UIImage *image;
    
    if (imageRef) {
        image = [UIImage imageWithCGImage:imageRef];
    }
    
    imageView.image = image;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

//this is for making an album heading
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"reusable view" forIndexPath:indexPath];
    
    if ([kind isEqual:UICollectionElementKindSectionHeader]) {
        static NSInteger headerLabelTag = 2468;
        
        UILabel *label = (UILabel *)[view viewWithTag:headerLabelTag];
        
        if (!label) {
            label = [[UILabel alloc] initWithFrame:view.bounds];
            label.tag = headerLabelTag;
            label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            label.textAlignment = NSTextAlignmentCenter;
            
            label.backgroundColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:235/255.0f alpha:1.0f];
            
            [view addSubview:label];
        }
        
        ALAssetsGroup *group = self.groups[indexPath.section];
        
        //Use any color you want or skip defining it
        UIColor* textColor = [UIColor colorWithWhite:0.35 alpha:1];
        
        NSDictionary *textAttributes = @{NSForegroundColorAttributeName : textColor,
                                         NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Medium" size:14],
                                         NSTextEffectAttributeName : NSTextEffectLetterpressStyle};
        
        NSAttributedString* attributedString;
        
        
        NSString *groupName = [group valueForProperty:ALAssetsGroupPropertyName];
        
        if (groupName) {
            attributedString = [[NSAttributedString alloc] initWithString:groupName attributes:textAttributes];
        }
        
        label.attributedText = attributedString;
    }
    
    return view;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = self.arraysOfAssets[indexPath.section][indexPath.row];
    ALAssetRepresentation *representation = asset.defaultRepresentation;
    CGImageRef imageRef = representation.fullResolutionImage;

    NSLog(@"image selected!");
    
    UIImage *newProfileImage;
    
    if (imageRef) {
        newProfileImage = [UIImage imageWithCGImage:imageRef scale:representation.scale orientation:(UIImageOrientation)representation.orientation];
    }
    
    [self.delegate imageLibraryViewController:self didCompleteWithImage:newProfileImage];
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
