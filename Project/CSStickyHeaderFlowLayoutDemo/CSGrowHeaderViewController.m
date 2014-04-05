//
//  CSGrowHeaderViewController.m
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by James Tang on 13/2/14.
//  Copyright (c) 2014 Jamz Tang. All rights reserved.
//

#import "CSGrowHeaderViewController.h"
#import "CSCell.h"
#import "CSStickyHeaderFlowLayout.h"
#import "URBMediaFocusViewController.h"

@interface CSGrowHeaderViewController ()

@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) UINib *headerNib;
@property (nonatomic, strong) URBMediaFocusViewController *controller;

@end

@implementation CSGrowHeaderViewController


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.sections = @[
                          @{@"Twitter":@"http://twitter.com"},
                          @{@"Facebook":@"http://facebook.com"},
                          @{@"Tumblr":@"http://tumblr.com"},
                          @{@"Pinterest":@"http://pinterest.com"},
                          @{@"Instagram":@"http://instagram.com"},
                          @{@"Github":@"http://github.com"},
                          ];
        
        self.headerNib = [UINib nibWithNibName:@"CSGrowHeader" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CSStickyHeaderFlowLayout *layout = (id)self.collectionViewLayout;
    
    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        layout.parallaxHeaderReferenceSize = CGSizeMake(320, 200);
    }

    // If we want to disable the sticky header effect
    layout.disableStickyHeaders = YES;

    // Also insets the scroll indicator so it appears below the search bar
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(44, 0, 0, 0);
    
    [self.collectionView registerNib:self.headerNib
          forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
                 withReuseIdentifier:@"header"];
    
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
        
        CSCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
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


#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    URBMediaFocusViewController *controller = [[URBMediaFocusViewController alloc] init];

    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];

//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    UIImageView *imageView = (id)[cell viewWithTag:1000];

    UIImage *image = imageView.image;

    CGRect rect = [imageView convertRect:imageView.bounds toView:nil];
    [controller showImage:image fromRect:rect];

    self.controller = controller;

}

@end
