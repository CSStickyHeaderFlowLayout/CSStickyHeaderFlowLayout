//
//  CSAlwaysOnTopHeader.m
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by James Tang on 6/4/14.
//  Copyright (c) 2014 Jamz Tang. All rights reserved.
//

#import "CSAlwaysOnTopHeader.h"

@implementation CSAlwaysOnTopHeader

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect frame = self.frame;

    [UIView beginAnimations:@"" context:nil];
    if (frame.size.height <= 110) {
        self.titleLabel.alpha = 1;
    } else {
        self.titleLabel.alpha = 0;
    }
    [UIView commitAnimations];
}

@end
