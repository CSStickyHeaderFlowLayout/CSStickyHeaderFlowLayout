//
//  CSBaseCollectionViewCell.m
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by James Tang on 17/9/14.
//  Copyright (c) 2014 Jamz Tang. All rights reserved.
//

#import "CSBaseCollectionViewCell.h"

@implementation CSBaseCollectionViewCell

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.contentView.frame = bounds;
}

@end
