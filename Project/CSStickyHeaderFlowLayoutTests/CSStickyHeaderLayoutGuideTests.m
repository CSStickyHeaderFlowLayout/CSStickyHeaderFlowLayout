//
//  CSStickyHeaderLayoutGuideTests.m
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by James Tang on 19/7/15.
//  Copyright (c) 2015 Jamz Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CSStickyHeaderLayoutGuide.h"

@interface CSStickyHeaderLayoutGuideTests : XCTestCase

@property (nonatomic, strong) CSStickyHeaderLayoutGuide *guide;

@end

@implementation CSStickyHeaderLayoutGuideTests

- (void)setUp {
    [super setUp];

    self.guide = [[CSStickyHeaderLayoutGuide alloc] init];
}

- (void)tearDown {

    self.guide = nil;
    [super tearDown];
}

- (void)testDefaults {
    XCTAssertEqual(self.guide.minimumLineSpacing, 10);
    XCTAssertEqual(self.guide.minimumInteritemSpacing, 10);
    XCTAssertEqualObjects(NSStringFromCGSize(self.guide.itemSize), @"{50, 50}");
    XCTAssertEqual(self.guide.scrollDirection, CSStickyHeaderLayoutDirectionVertical);
    XCTAssertEqualObjects(NSStringFromCGSize(self.guide.headerReferenceSize), @"{0, 0}");
    XCTAssertEqualObjects(NSStringFromCGSize(self.guide.footerReferenceSize), @"{0, 0}");
    XCTAssertEqualObjects(NSStringFromCGSize(self.guide.headerReferenceSize), @"{0, 0}");
    XCTAssertEqualObjects(NSStringFromCSEdgeInsets(self.guide.sectionInset), @"{0, 0, 0, 0}");
    XCTAssertEqualObjects(NSStringFromCGSize(self.guide.parallaxHeaderReferenceSize), @"{0, 0}");
    XCTAssertEqualObjects(NSStringFromCGSize(self.guide.parallaxHeaderMinimumReferenceSize), @"{0, 0}");
    XCTAssertEqual(self.guide.parallaxHeaderAlwaysOnTop, NO);
    XCTAssertEqual(self.guide.disableStickyHeaders, NO);
    XCTAssertEqualObjects(self.guide.items, @[]);
}


@end
