/*
 * This file is part of the CSStickyHeaderFlowLayout package.
 * (c) James Tang <j@jamztang.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <UIKit/UIKit.h>

extern NSString *const CSStickyHeaderParallaxHeader;

@protocol CSStickyHeaderFlowLayoutDelegate <NSObject>

@optional
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface CSStickyHeaderFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<CSStickyHeaderFlowLayoutDelegate> delegate;
@property (nonatomic) CGSize parallaxHeaderReferenceSize;
@property (nonatomic) CGSize parallaxHeaderMinimumReferenceSize;
@property (nonatomic) BOOL parallaxHeaderAlwaysOnTop;
@property (nonatomic) BOOL disableStickyHeaders;

@end
