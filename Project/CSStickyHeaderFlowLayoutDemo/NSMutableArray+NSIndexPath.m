//
//  NSMutableArray+NSIndexPath.m
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by James Tang on 17/9/14.
//  Copyright (c) 2014 Jamz Tang. All rights reserved.
//

#import "NSMutableArray+NSIndexPath.h"


@implementation NSMutableArray (NSIndexPath)

- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
    NSMutableArray *section = self[indexPath.section];
    id object = section[indexPath.row];

    NSMutableArray *newSection = self[newIndexPath.section];

    [section removeObjectAtIndex:indexPath.row];
    [newSection insertObject:object atIndex:newIndexPath.row];
}

@end