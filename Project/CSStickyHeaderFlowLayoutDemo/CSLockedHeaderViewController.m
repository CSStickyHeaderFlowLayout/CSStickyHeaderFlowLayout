//
//  CSLockedHeaderViewController.m
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by James Tang on 11/2/14.
//  Copyright (c) 2014 James Tang. All rights reserved.
//

#import "CSLockedHeaderViewController.h"
#import "CSCell.h"
#import "CSSectionHeader.h"
#import "CSStickyHeaderFlowLayout.h"

@interface CSLockedHeaderViewController ()

@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) UINib *headerNib;

@end

@implementation CSLockedHeaderViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.sections = @[];
        
        self.headerNib = [UINib nibWithNibName:@"CSSearchBarHeader" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self reloadLayout];
    
    // Also insets the scroll indicator so it appears below the search bar
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(44, 0, 0, 0);
    
    [self.collectionView registerNib:self.headerNib
          forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
                 withReuseIdentifier:@"header"];
    
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(add:)];
    self.navigationItem.rightBarButtonItem = add;

    [self add:nil];
    
}

- (void)add:(id)sender
{
//    NSArray *new = @[
//                     @{@"Twitter":@"http://twitter.com"},
//                     @{@"Facebook":@"http://facebook.com"},
//                     @{@"Tumblr":@"http://tumblr.com"},
//                     @{@"Pinterest":@"http://pinterest.com"},
//                     @{@"Instagram":@"http://instagram.com"},
//                     @{@"Github":@"http://github.com"},
//                     @{@"Twitter":@"http://twitter.com"},
//                     @{@"Facebook":@"http://facebook.com"},
//                     @{@"Tumblr":@"http://tumblr.com"},
//                     @{@"Pinterest":@"http://pinterest.com"},
//                     @{@"Instagram":@"http://instagram.com"},
//                     @{@"Github":@"http://github.com"},
//                     ];
//    self.sections = [self.sections arrayByAddingObjectsFromArray:new];
//    [self.collectionView reloadData];

    [self.collectionView performBatchUpdates:^{

        NSArray *new = @[
                         @{@"Twitter":@"http://twitter.com"},
                         @{@"Facebook":@"http://facebook.com"},
                         @{@"Tumblr":@"http://tumblr.com"},
                         @{@"Pinterest":@"http://pinterest.com"},
                         @{@"Instagram":@"http://instagram.com"},
                         @{@"Github":@"http://github.com"},
                         @{@"Twitter":@"http://twitter.com"},
                         @{@"Facebook":@"http://facebook.com"},
                         @{@"Tumblr":@"http://tumblr.com"},
                         @{@"Pinterest":@"http://pinterest.com"},
                         @{@"Instagram":@"http://instagram.com"},
                         @{@"Github":@"http://github.com"},
                         ];
        self.sections = [self.sections arrayByAddingObjectsFromArray:new];

        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        NSMutableArray *indexPaths = [NSMutableArray array];

        int startIndex = 0;

        [new enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL *stop) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:startIndex + idx];
            [indexPaths addObject:indexPath];

            [set addIndex:startIndex + idx];
            
        }];
        
        [self.collectionView insertSections:set];
        [self.collectionView insertItemsAtIndexPaths:indexPaths];
    } completion:nil];

}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self reloadLayout];
}

- (void)reloadLayout {
    CSStickyHeaderFlowLayout *layout = (id)self.collectionViewLayout;

    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        layout.parallaxHeaderReferenceSize = CGSizeMake(self.view.frame.size.width, 44);
        layout.itemSize = CGSizeMake(self.view.frame.size.width, layout.itemSize.height);

        // Setting the minimum size equal to the reference size results
        // in disabled parallax effect and pushes up while scrolls
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.view.frame.size.width, 44);
    }
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.sections count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *obj = self.sections[indexPath.section];
    
    CSCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                             forIndexPath:indexPath];
    
    cell.textLabel.text = [[obj allValues] firstObject];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        NSDictionary *obj = self.sections[indexPath.section];
        
        CSSectionHeader *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:@"sectionHeader"
                                                                 forIndexPath:indexPath];
        
        cell.textLabel.text = [[obj allKeys] firstObject];
        
        return cell;
    } else if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:@"header"
                                                                                   forIndexPath:indexPath];
        
        return cell;
    }
    return nil;
}

#pragma mark UICollectionViewDataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"hit test");
}

@end
