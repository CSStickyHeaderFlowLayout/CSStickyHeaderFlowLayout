//
//  CSStickyHeaderLayoutGuide.h
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by James Tang on 19/7/15.
//  Copyright (c) 2015 Jamz Tang. All rights reserved.
//
// Testable object behind CSStickyHeaderFlowLayout

#import <Foundation/Foundation.h>
@import QuartzCore;


typedef NS_ENUM(NSInteger, CSStickyHeaderLayoutDirection) {
    CSStickyHeaderLayoutDirectionVertical,
};

typedef struct CSEdgeInsets {
    CGFloat top, left, bottom, right;  // specify amount to inset (positive) for each of the edges. values can be negative to 'outset'
} CSEdgeInsets;

static inline NSString * __nonnull NSStringFromCSEdgeInsets(CSEdgeInsets insets) {
    return [NSString stringWithFormat:@"{%@, %@, %@, %@}", @(insets.top), @(insets.left), @(insets.bottom), @(insets.right)];
}

typedef CGSize(^CSStickyHeaderLayoutSizeHandler)(void);

@interface CSStickyHeaderLayoutItem : NSObject

@property (nonatomic, copy, nullable) CSStickyHeaderLayoutSizeHandler sizeHandler;

+ (nonnull instancetype)itemWithSizeHandler:(__nullable CSStickyHeaderLayoutSizeHandler)handler;

@end


@interface CSStickyHeaderLayoutGuide : NSObject

@property (nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic) CGFloat minimumInteritemSpacing;
@property (nonatomic) CGSize itemSize;    // If items.size is specified, then itemSize will be ignored
@property (nonatomic) CSStickyHeaderLayoutDirection scrollDirection; // default is CSStickyHeaderLayoutDirectionVertical
@property (nonatomic) CGSize headerReferenceSize;
@property (nonatomic) CGSize footerReferenceSize;
@property (nonatomic) CSEdgeInsets sectionInset;

@property (nonatomic) CGSize parallaxHeaderReferenceSize;
@property (nonatomic) CGSize parallaxHeaderMinimumReferenceSize;
@property (nonatomic) BOOL parallaxHeaderAlwaysOnTop;
@property (nonatomic) BOOL disableStickyHeaders;

@property (nonatomic, copy, nonnull) NSArray *items;

@end
