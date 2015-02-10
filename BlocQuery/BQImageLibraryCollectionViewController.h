//
//  BQImageLibraryCollectionViewController.h
//  BlocQuery
//
//  Created by Stephen Palley on 2/9/15.
//  Copyright (c) 2015 Steve Palley. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BQImageLibraryCollectionViewController;

@protocol BQImageLibraryViewControllerDelegate <NSObject>

- (void) imageLibraryViewController:(BQImageLibraryCollectionViewController *) controller didCompleteWithImage:(UIImage *)image;

@end

@interface BQImageLibraryCollectionViewController : UICollectionViewController

@property (nonatomic, weak) NSObject <BQImageLibraryViewControllerDelegate> *delegate;

@end
