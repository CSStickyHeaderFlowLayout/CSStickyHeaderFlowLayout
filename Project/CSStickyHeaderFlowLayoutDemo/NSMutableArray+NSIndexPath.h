//
//  NSMutableArray+NSIndexPath.h
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by James Tang on 17/9/14.
//  Copyright (c) 2014 Jamz Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (NSIndexPath)

- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath;

@end