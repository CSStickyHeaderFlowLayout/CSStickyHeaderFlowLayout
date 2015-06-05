/*
 * This file is part of the CSStickyHeaderFlowLayout package.
 * (c) James Tang <j@jamztang.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "CSStickyHeaderFlowLayoutAttributes.h"

@implementation CSStickyHeaderFlowLayoutAttributes

- (id)copyWithZone:(NSZone *)zone {
  typeof(self) copy = [super copyWithZone:zone];
  copy.progressiveness = self.progressiveness;
  return copy;
}

- (void)setZIndex:(NSInteger)zIndex {
    [super setZIndex:zIndex];

    // Fixes: Section header go behind cell when insert via performBatchUpdates #68
    // https://github.com/jamztang/CSStickyHeaderFlowLayout/issues/68#issuecomment-108678022
    // Reference: UICollectionView setLayout:animated: not preserving zIndex
    // http://stackoverflow.com/questions/12659301/uicollectionview-setlayoutanimated-not-preserving-zindex

    // originally our solution is to translate the section header above the original z position,
    // however, scroll indicator will be covered by those cells and section header if z position is >= 1
    // so instead we translate the original cell to be -1, and make sure the cell are hit test proven.
    self.transform3D = CATransform3DMakeTranslation(0, 0, zIndex == 1 ? -1 : 0);
}

@end
