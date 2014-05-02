//
//  CSAlwaysOnTopHeader.m
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by James Tang on 6/4/14.
//  Copyright (c) 2014 Jamz Tang. All rights reserved.
//

#import "CSAlwaysOnTopHeader.h"
#import "CSStickyHeaderFlowLayoutAttributes.h"

@implementation CSAlwaysOnTopHeader

- (void)applyLayoutAttributes:(CSStickyHeaderFlowLayoutAttributes *)layoutAttributes {

    [UIView beginAnimations:@"" context:nil];

    if (layoutAttributes.progressiveness <= 0.58) {
        self.titleLabel.alpha = 1;
    } else {
        self.titleLabel.alpha = 0;
    }

    if (layoutAttributes.progressiveness >= 1) {
        self.searchBar.alpha = 1;
    } else {
        self.searchBar.alpha = 0;
    }

    [UIView commitAnimations];
}

@end
