//
//  CSStickyHeaderLayoutGuide.m
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by James Tang on 19/7/15.
//  Copyright (c) 2015 Jamz Tang. All rights reserved.
//

#import "CSStickyHeaderLayoutGuide.h"

@implementation CSStickyHeaderLayoutGuide

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.minimumLineSpacing = 10;
        self.minimumInteritemSpacing = 10;
        self.itemSize = CGSizeMake(50, 50);
        self.items = @[];
    }
    return self;
}

@end
