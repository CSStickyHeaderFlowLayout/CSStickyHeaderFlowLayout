//
//  UICollectionView+CSPrefetchSwitch.m
//  Pods
//
//  Created by Monzy Zhang on 14/09/2016.
//
//

#import "UICollectionView+CSPrefetchSwitch.h"

@implementation UICollectionView (CSPrefetchSwitch)

- (void)cs_setPrefetchingEnabled:(BOOL)enabled
{
    NSString *prefetchStr = @"setPrefetchingEnabled:";
    SEL setPrefetch = NSSelectorFromString(prefetchStr);
    if (![self respondsToSelector:setPrefetch]) {
        return;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if (!enabled) {
        [self performSelector:setPrefetch withObject:nil];
    } else {
        [self performSelector:setPrefetch withObject:@(YES)];
    }
#pragma clang diagnostic pop
}

@end
