/*
 * This file is part of the CSStickyHeaderFlowLayout package.
 * (c) James Tang <j@jamztang.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <UIKit/UIKit.h>

//! Project version number for CSStickyHeaderFlowLayout.
FOUNDATION_EXPORT double CSStickyHeaderFlowLayoutVersionNumber;

//! Project version string for CSStickyHeaderFlowLayout.
FOUNDATION_EXPORT const unsigned char CSStickyHeaderFlowLayoutVersionString[];

// Import All public headers
#import <CSStickyHeaderFlowLayout/CSStickyHeaderFlowLayoutAttributes.h>

#pragma mark -

extern NSString *const CSStickyHeaderParallaxHeader;

@interface CSStickyHeaderFlowLayout : UICollectionViewFlowLayout

@property (nonatomic) CGSize parallaxHeaderReferenceSize;
@property (nonatomic) CGSize parallaxHeaderMinimumReferenceSize;
@property (nonatomic) BOOL parallaxHeaderAlwaysOnTop;
@property (nonatomic) BOOL disableStickyHeaders;
- (NSArray *)customLayoutAttributesForElementsInRect:(CGRect)rect;
- (UICollectionViewLayoutAttributes *)customLayoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGSize)customCollectionViewContentSize;

@end
