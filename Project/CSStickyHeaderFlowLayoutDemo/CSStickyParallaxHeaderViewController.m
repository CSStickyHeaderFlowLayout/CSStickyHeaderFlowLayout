//
//  CSStickyParallaxHeaderViewController.m
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by James Tang on 6/4/14.
//  Copyright (c) 2014 Jamz Tang. All rights reserved.
//

#import "CSStickyParallaxHeaderViewController.h"
#import "CSCell.h"
#import "CSSectionHeader.h"
#import "CSStickyHeaderFlowLayout.h"

@interface CSStickyParallaxHeaderViewController ()

@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) UINib *headerNib;

@end

@implementation CSStickyParallaxHeaderViewController


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.sections = @[
                          @[
                              @"Song 1",
                              @"Song 2",
                              @"Song 3",
                              @"Song 4",
                              @"Song 5",
                              @"Song 6",
                              @"Song 7",
                              @"Song 8",
                              @"Song 9",
                              @"Song 10",
                              @"Song 11",
                              @"Song 12",
                              @"Song 13",
                              @"Song 14",
                              @"Song 15",
                              @"Song 16",
                              @"Song 17",
                              @"Song 18",
                              @"Song 19",
                              @"Song 20",
                            ],
                          ];

        self.headerNib = [UINib nibWithNibName:@"CSAlwaysOnTopHeader" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self reloadLayout];

    // Also insets the scroll indicator so it appears below the search bar
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);

    [self.collectionView registerNib:self.headerNib
          forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
                 withReuseIdentifier:@"header"];

}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self reloadLayout];
}

- (void)reloadLayout {

    CSStickyHeaderFlowLayout *layout = (id)self.collectionViewLayout;

    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        layout.parallaxHeaderReferenceSize = CGSizeMake(self.view.frame.size.width, 426);
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.view.frame.size.width, 110);
        layout.itemSize = CGSizeMake(self.view.frame.size.width, layout.itemSize.height);
        layout.parallaxHeaderAlwaysOnTop = YES;

        // If we want to disable the sticky header effect
        layout.disableStickyHeaders = YES;
    }

}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.sections count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.sections[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    NSString *obj = self.sections[indexPath.section][indexPath.row];

    CSCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                             forIndexPath:indexPath];

    cell.textLabel.text = obj;

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {

        CSSectionHeader *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:@"sectionHeader"
                                                                 forIndexPath:indexPath];

        return cell;

    } else if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:@"header"
                                                                                   forIndexPath:indexPath];

        return cell;
    }
    return nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}



@end
