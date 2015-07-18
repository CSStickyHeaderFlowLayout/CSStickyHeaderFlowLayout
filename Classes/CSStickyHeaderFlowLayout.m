/*
 * This file is part of the CSStickyHeaderFlowLayout package.
 * (c) James Tang <j@jamztang.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "CSStickyHeaderFlowLayout.h"
#import "CSStickyHeaderFlowLayoutAttributes.h"


NSString *const CSStickyHeaderParallaxHeader = @"CSStickyHeaderParallexHeader";
static const NSInteger kHeaderZIndex = 1024;

@interface CSStickyHeaderFlowLayout (Debug)

- (void)debugLayoutAttributes:(NSArray *)layoutAttributes;

@end


@implementation CSStickyHeaderFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind
                                                                                        atIndexPath:(NSIndexPath *)elementIndexPath {
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath];

    if ([elementKind isEqualToString:CSStickyHeaderParallaxHeader]) {
        // sticky header do not need to offset
        return nil;
    } else {
        // offset others

        CGRect frame = attributes.frame;
        frame.origin.y += self.parallaxHeaderReferenceSize.height;
        attributes.frame = frame;
    }

    return attributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath {

    if ([elementKind isEqualToString:CSStickyHeaderParallaxHeader]) {
        CSStickyHeaderFlowLayoutAttributes *attribute = (CSStickyHeaderFlowLayoutAttributes *)[self layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:elementIndexPath];

        [self updateParallaxHeaderAttribute:attribute];
        return attribute;
    } else {
        return [super finalLayoutAttributesForDisappearingSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath];
    }
    return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    if (!attributes && [kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        attributes = [CSStickyHeaderFlowLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    }
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // The rect should compensate the header size
    CGRect adjustedRect = rect;
    adjustedRect.origin.y -= self.parallaxHeaderReferenceSize.height;

    NSMutableArray *allItems = [[super layoutAttributesForElementsInRect:adjustedRect] mutableCopy];

    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *lastCells = [[NSMutableDictionary alloc] init];
    __block BOOL visibleParallexHeader;

    [allItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UICollectionViewLayoutAttributes *attributes = obj;

        CGRect frame = attributes.frame;
        frame.origin.y += self.parallaxHeaderReferenceSize.height;
        attributes.frame = frame;

        NSIndexPath *indexPath = [(UICollectionViewLayoutAttributes *)obj indexPath];
        BOOL isHeader = [[obj representedElementKind] isEqualToString:UICollectionElementKindSectionHeader];
        BOOL isFooter = [[obj representedElementKind] isEqualToString:UICollectionElementKindSectionFooter];

        if (isHeader) {
            [headers setObject:obj forKey:@(indexPath.section)];
        } else if (isFooter) {
            // Not implemeneted
        } else {
            UICollectionViewLayoutAttributes *currentAttribute = [lastCells objectForKey:@(indexPath.section)];

            // Get the bottom most cell of that section
            if ( ! currentAttribute || indexPath.row > currentAttribute.indexPath.row) {
                [lastCells setObject:obj forKey:@(indexPath.section)];
            }

            if ([indexPath item] == 0 && [indexPath section] == 0) {
                visibleParallexHeader = YES;
            }
        }

        if (isHeader) {
            attributes.zIndex = kHeaderZIndex;
        } else {
            // For iOS 7.0, the cell zIndex should be above sticky section header
            attributes.zIndex = 1;
        }
    }];

    // when the visible rect is at top of the screen, make sure we see
    // the parallex header
    if (CGRectGetMinY(rect) <= 0) {
        visibleParallexHeader = YES;
    }

    if (self.parallaxHeaderAlwaysOnTop == YES) {
        visibleParallexHeader = YES;
    }


    // This method may not be explicitly defined, default to 1
    // https://developer.apple.com/library/ios/documentation/uikit/reference/UICollectionViewDataSource_protocol/Reference/Reference.html#jumpTo_6
//    NSUInteger numberOfSections = [self.collectionView.dataSource
//                                   respondsToSelector:@selector(numberOfSectionsInCollectionView:)]
//                                ? [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView]
//                                : 1;

    // Create the attributes for the Parallex header
    if (visibleParallexHeader && ! CGSizeEqualToSize(CGSizeZero, self.parallaxHeaderReferenceSize)) {
        CSStickyHeaderFlowLayoutAttributes *currentAttribute = [CSStickyHeaderFlowLayoutAttributes layoutAttributesForSupplementaryViewOfKind:CSStickyHeaderParallaxHeader withIndexPath:[NSIndexPath indexPathWithIndex:0]];
        [self updateParallaxHeaderAttribute:currentAttribute];

        [allItems addObject:currentAttribute];
    }

    if ( ! self.disableStickyHeaders) {
        [lastCells enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSIndexPath *indexPath = [obj indexPath];
            NSNumber *indexPathKey = @(indexPath.section);

            UICollectionViewLayoutAttributes *header = headers[indexPathKey];
            // CollectionView automatically removes headers not in bounds
            if ( ! header) {
                header = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                              atIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.section]];

                if (header) {
                    [allItems addObject:header];
                }
            }
            [self updateHeaderAttributes:header lastCellAttributes:lastCells[indexPathKey]];
        }];
    }

    // For debugging purpose
//     [self debugLayoutAttributes:allItems];

    return allItems;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    CGRect frame = attributes.frame;
    frame.origin.y += self.parallaxHeaderReferenceSize.height;
    attributes.frame = frame;
    return attributes;
}

- (CGSize)collectionViewContentSize {
    // If not part of view hierarchy then return CGSizeZero (as in docs).
    // Call [super collectionViewContentSize] can cause EXC_BAD_ACCESS when collectionView has no superview.
    if (!self.collectionView.superview) {
        return CGSizeZero;
    }
    CGSize size = [super collectionViewContentSize];
    size.height += self.parallaxHeaderReferenceSize.height;
    return size;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

#pragma mark Overrides

+ (Class)layoutAttributesClass {
    return [CSStickyHeaderFlowLayoutAttributes class];
}

- (void)setParallaxHeaderReferenceSize:(CGSize)parallaxHeaderReferenceSize {
    _parallaxHeaderReferenceSize = parallaxHeaderReferenceSize;
    // Make sure we update the layout
    [self invalidateLayout];
}

#pragma mark Helper

- (void)updateHeaderAttributes:(UICollectionViewLayoutAttributes *)attributes lastCellAttributes:(UICollectionViewLayoutAttributes *)lastCellAttributes
{
    CGRect currentBounds = self.collectionView.bounds;
    attributes.zIndex = kHeaderZIndex;
    attributes.hidden = NO;

    CGPoint origin = attributes.frame.origin;

    CGFloat sectionMaxY = CGRectGetMaxY(lastCellAttributes.frame) - attributes.frame.size.height;
    CGFloat y = CGRectGetMaxY(currentBounds) - currentBounds.size.height + self.collectionView.contentInset.top;

    if (self.parallaxHeaderAlwaysOnTop) {
        y += self.parallaxHeaderMinimumReferenceSize.height;
    }

    CGFloat maxY = MIN(MAX(y, attributes.frame.origin.y), sectionMaxY);

//    NSLog(@"%.2f, %.2f, %.2f", y, maxY, sectionMaxY);

    origin.y = maxY;

    attributes.frame = (CGRect){
        origin,
        attributes.frame.size
    };
}

- (void)updateParallaxHeaderAttribute:(CSStickyHeaderFlowLayoutAttributes *)currentAttribute {

    CGRect frame = currentAttribute.frame;
    frame.size.width = self.parallaxHeaderReferenceSize.width;
    frame.size.height = self.parallaxHeaderReferenceSize.height;

    CGRect bounds = self.collectionView.bounds;
    CGFloat maxY = CGRectGetMaxY(frame);

    // make sure the frame won't be negative values
    CGFloat y = MIN(maxY - self.parallaxHeaderMinimumReferenceSize.height, bounds.origin.y + self.collectionView.contentInset.top);
    CGFloat height = MAX(0, -y + maxY);


    CGFloat maxHeight = self.parallaxHeaderReferenceSize.height;
    CGFloat minHeight = self.parallaxHeaderMinimumReferenceSize.height;
    CGFloat progressiveness = (height - minHeight)/(maxHeight - minHeight);
    currentAttribute.progressiveness = progressiveness;

    // if zIndex < 0 would prevents tap from recognized right under navigation bar
    currentAttribute.zIndex = 0;

    // When parallaxHeaderAlwaysOnTop is enabled, we will check when we should update the y position
    if (self.parallaxHeaderAlwaysOnTop && height <= self.parallaxHeaderMinimumReferenceSize.height) {
        CGFloat insetTop = self.collectionView.contentInset.top;
        // Always stick to top but under the nav bar
        y = self.collectionView.contentOffset.y + insetTop;
        currentAttribute.zIndex = 2000;
    }

    currentAttribute.frame = (CGRect){
        frame.origin.x,
        y,
        frame.size.width,
        height,
    };
    
}

@end

#pragma mark - Debugging

@implementation CSStickyHeaderFlowLayoutAttributes (Debug)

- (NSString *)description {
    NSString *indexPathString = [NSString stringWithFormat:@"{%ld, %ld}", (long)self.indexPath.section, (long)self.indexPath.item];

    NSString *desc = [NSString stringWithFormat:@"<CSStickyHeaderFlowLayout: %p> indexPath: %@ zIndex: %ld valid: %@ kind: %@", self, indexPathString, (long)self.zIndex, [self isValid] ? @"YES" : @"NO", self.representedElementKind ?: @"cell"];

    return desc;
}

- (BOOL)isValid {
    switch (self.representedElementCategory) {
        case UICollectionElementCategoryCell:
            if (self.zIndex != 1) {
                return NO;
            }
            return YES;
        case UICollectionElementCategorySupplementaryView:
            if ([self.representedElementKind isEqualToString:CSStickyHeaderParallaxHeader]) {
                return YES;
            } else if (self.zIndex < 1024) {
                return NO;
            }
            return YES;
        default:
            return YES;
    }
}

@end


@implementation CSStickyHeaderFlowLayout (Debug)

- (void)debugLayoutAttributes:(NSArray *)layoutAttributes {
    __block BOOL hasInvalid = NO;
    [layoutAttributes enumerateObjectsUsingBlock:^(CSStickyHeaderFlowLayoutAttributes *attr, NSUInteger idx, BOOL *stop) {
        hasInvalid = ![attr isValid];
        if (hasInvalid) {
            *stop = YES;
        }
    }];

    if (hasInvalid) {
        NSLog(@"CSStickyHeaderFlowLayout: %@", layoutAttributes);
    }
}

@end

