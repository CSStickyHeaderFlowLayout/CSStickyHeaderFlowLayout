# CSStickyHeaderFlowLayout

<!--![](http://cl.ly/image/1D2i0746180b/1*pev9ZXJAZ2MYoF8-R_nbRA.gif)-->

<img src="http://f.cl.ly/items/05130s2r0X1j1x1N0Q3n/spotify-48-16-half.gif" width="276"/>
<img src="http://f.cl.ly/items/3q2u35013o0y0G2o3X1v/carshare-32-16-half.gif" width="276"/>
<img src="http://f.cl.ly/items/3l0F1F3Y0s1M1F3a2r0d/ripple.gif" width="276"/>

Parallax, Sticky Headers, Growing image heading, done right in one
UICollectionViewLayout.

## Installation

[![Version](http://cocoapod-badges.herokuapp.com/v/CSStickyHeaderFlowLayout/badge.png)](http://cocoadocs.org/docsets/CSStickyHeaderFlowLayout)
[![Platform](http://cocoapod-badges.herokuapp.com/p/CSStickyHeaderFlowLayout/badge.png)](http://cocoadocs.org/docsets/CSStickyHeaderFlowLayout)


CSStickyHeaderFlowLayout is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "CSStickyHeaderFlowLayout"

Alternatively, you can just drag the files from `CSStickyHeaderFlowLayout / Classes` into your own project.


## Usage (Swift/Code)

Documentation is coming soon. For now please open `CSStickyHeaderFlowLayout.xcworkspace` > `SwiftDemo` target.

## Usage (CocoaPods/Objective-C/Storyboard)

To run the example project; clone the repo, and run `pod install` from the Project directory first.

**1. Setting up the Sticky Section Header**

Configure your collection view to use `CSStickyHeaderFlowLayout`. Here's an example on how you to do it in Storyboard.

![](http://f.cl.ly/items/32183h2q18171k323J07/csstickyheaderflowlayout-class.jpg)

Now all your **section headers** will get the sticky effect like table view. You can disable it with one line of code.

```objective-c
@property (nonatomic) BOOL disableStickyHeaders;
```

**2. Setting up the Collection View Header**

We'll be using _supplementary views_ for our parallax header. Here's an example on how use a nib file for that purpose:

![](http://f.cl.ly/items/0x1L0U2x1U0g2q2E1i3Z/header-grow.jpeg)

Register that nib file to your collection view controller in code:

```objective-c
#import "CSStickyHeaderFlowLayout.h"

- (void)viewDidLoad {

    [super viewDidLoad];

    // Locate your layout
    CSStickyHeaderFlowLayout *layout = (id)self.collectionViewLayout;
    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        layout.parallaxHeaderReferenceSize = CGSizeMake(320, 200);
    }

    // Locate the nib and register it to your collection view
    UINib *headerNib = [UINib nibWithNibName:@"CSGrowHeader" bundle:nil];
    [self.collectionView registerNib:headerNib
          forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
                 withReuseIdentifier:@"header"];

}
```

Implement `-[UICollectionViewDataSource collectionView:viewForSupplementaryElementOfKind:atIndexPath:]`

```objective-c
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    // Check the kind if it's CSStickyHeaderParallaxHeader
    if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {

        UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:@"header"
                                                                                   forIndexPath:indexPath];

        return cell;

    } else if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        // Your code to configure your section header...
    } else {
        // other custom supplementary views
    }
    return nil;
}
```

That's it. You'll be able to get the header you wanted using the best practice.

Configuring other effects are really just the way how you setup the header cell, by combining different settings in the minimal exposed properties in [CSStickyHeaderFlowLayout.h][]

```objective-c
@property (nonatomic) CGSize parallaxHeaderReferenceSize;
@property (nonatomic) CGSize parallaxHeaderMinimumReferenceSize;
@property (nonatomic) BOOL disableStickyHeaders;
```

Run the project examples and it'll shows you exactly how you achieve different effects.

![](http://f.cl.ly/items/313D2n3R0H0e0x090B3X/different-header.jpeg)



## Donation

If you think this worths something, tip me a cup of coffee! (p.s. was trying out ChangeTip, or if you know any better donation button, let [me](http://twitter.com/@jamztang) know) :)

<a target="_blank" href="http://jamztang.tip.me">
  <img
    alt="Tip Me With ChangeTip"
    src="https://cdn.changetip.com/img/logos/tipme_round.png"/>
</a>


## Updates

- 0.2.8: Fixed a visual issue when animating contentInsets #85 and crash when dragging cells #69

- 0.2.7: Fixed scroll indicator covered by cell

- 0.2.6: Fixing that section header being covered by cell after perform batch update

- 0.2.5: Fixing a crash when quickly popping back to a view controller using the parallax header

- 0.2.4: Possibly fix for a crash when parallaxHeaderReferenceSize is changed

- 0.2.3: Enabled iPhone 6 screen sizes, reverted a patch and fixed a visual bug and content tapping bug.

- 0.2.2: Fix 1px header and zIndex problem, thanks
  [@m1entus](https://github.com/m1entus) and [@Xyand](https://github.com/Xyand)

- 0.2.1: Fix crash on reloadData in collection view when header is offscreen, thanks [@jessesquires](https://github.com/jessesquires)

- 0.2: Added custom UICollectionViewLayoutAttributes to support more advanced example (Spotify App)

- 0.1.1: Minor fixes for default number of sections, thanks [@miwillhite](https://github.com/miwillhite)

- 0.1: Initial Release

## Who's using it?

We've a [wiki page][made] for that, feel free to add your projects there!

## Requirements

- Xcode 5
- iOS 7 (I haven't really test on iOS 6 but it should work if you're using iOS 6 compatible Storyboard)

## Author

James Tang, j@jamztang.com

## License

CSStickyHeaderFlowLayout is available under the MIT license. See the LICENSE file for more info.

[CSStickyHeaderFlowLayout.h]:https://github.com/jamztang/CSStickyHeaderFlowLayout/blob/master/Classes/CSStickyHeaderFlowLayout.h

[Carshare]:http://carshare.hk
[Ripple]:http://ripplechat.io
[made]:https://github.com/jamztang/CSStickyHeaderFlowLayout/wiki
