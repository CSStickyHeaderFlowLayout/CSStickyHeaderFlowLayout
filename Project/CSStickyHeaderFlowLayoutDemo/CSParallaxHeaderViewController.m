//
//  ViewController.m
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by James Tang on 8/1/14.
//  Copyright (c) 2014 James Tang. All rights reserved.
//

#import "CSParallaxHeaderViewController.h"
#import "CSCell.h"
#import "CSStickyHeaderFlowLayout.h"
#import "NSMutableArray+NSIndexPath.h"

@interface CSParallaxHeaderViewController ()

@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) UINib *headerNib;

@end


@implementation CSParallaxHeaderViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.sections = @[
                          @[@{@"Twitter":@"http://twitter.com"}].mutableCopy,
                          @[
                              @{@"Facebook":@"http://facebook.com"},
                              @{@"Facebook":@"http://facebook.com"},
                              @{@"Facebook":@"http://facebook.com"},
                              @{@"Facebook":@"http://facebook.com"},
                              ].mutableCopy,
                          ];
        
        self.headerNib = [UINib nibWithNibName:@"CSParallaxHeader" bundle:nil];
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
    
    [self.collectionView registerNib:self.headerNib
          forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
                 withReuseIdentifier:@"header"];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (IBAction)swapButtonDidPress:(id)sender {

    [self.collectionView performBatchUpdates:^{

        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:1];
        NSIndexPath *toIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [[self mutableArrayValueForKey:@"sections"] moveItemAtIndexPath:indexPath toIndexPath:toIndexPath];
        [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:toIndexPath];
    } completion:^(BOOL finished) {

    }];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.sections count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.sections[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *obj = self.sections[indexPath.section][indexPath.item];

    CSCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                           forIndexPath:indexPath];
    
    cell.textLabel.text = [[obj allValues] firstObject];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {

        NSDictionary *obj = self.sections[indexPath.section][indexPath.item];

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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

@end
