/*
 * This file is part of the CSStickyHeaderFlowLayout package.
 * (c) James Tang <j@jamztang.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <UIKit/UIKit.h>

@interface CSStickyHeaderFlowLayoutAttributes : UICollectionViewLayoutAttributes

// 0 = minimized, 1 = fully expanded, > 1 = stretched
@property (nonatomic) CGFloat progressiveness;

@end
