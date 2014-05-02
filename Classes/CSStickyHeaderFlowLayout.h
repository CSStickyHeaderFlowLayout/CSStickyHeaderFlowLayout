/*
 * This file is part of the Canvas package.
 * (c) James Tang <jamz@jamztang.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <UIKit/UIKit.h>

extern NSString *const CSStickyHeaderParallaxHeader;

@interface CSStickyHeaderFlowLayout : UICollectionViewFlowLayout

@property (nonatomic) CGSize parallaxHeaderReferenceSize;
@property (nonatomic) CGSize parallaxHeaderMinimumReferenceSize;
@property (nonatomic) BOOL parallaxHeaderAlwaysOnTop;
@property (nonatomic) BOOL disableStickyHeaders;

@end
