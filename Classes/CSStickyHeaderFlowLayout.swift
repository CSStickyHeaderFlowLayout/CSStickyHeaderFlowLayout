//
//  CSStickyHeaderFlowLayout.swift
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by Christian Enevoldsen on 13/09/16.
//  Copyright © 2016 Jamz Tang. All rights reserved.
//

import UIKit


public let CSStickyHeaderParallaxHeader = "CSStickyHeaderParallaxHeader"

@objc public final class CSElementKind: NSObject {
  public class func stickyHeaderParallaxHeader() -> String {
    return CSStickyHeaderParallaxHeader
  }
}

public class CSStickyHeaderFlowLayout: UICollectionViewFlowLayout {

  public var parallaxHeaderReferenceSize = CGSize.zero {
    didSet {
      invalidateLayout()
    }
  }
  public var parallaxHeaderMinimumReferenceSize = CGSize.zero
  public var parallaxHeaderAlwaysOnTop = true
  public var disableStickyHeaders = false
  public var disableStretching = false

  public override class func layoutAttributesClass() -> AnyClass {
    return CSStickyHeaderFlowLayoutAttributes.self
  }

  public override func initialLayoutAttributesForAppearingSupplementaryElementOfKind(elementKind: String, atIndexPath elementIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {

    let attributes = super.initialLayoutAttributesForAppearingSupplementaryElementOfKind(elementKind, atIndexPath: elementIndexPath)

    guard elementKind == CSStickyHeaderParallaxHeader, let frame = attributes?.frame else {
      return nil
    }

    let origin = CGPoint(
      x: frame.origin.x,
      y: frame.origin.y + parallaxHeaderReferenceSize.height)

    attributes?.frame = CGRect(origin: origin, size: frame.size)

    return attributes
  }

  public override func finalLayoutAttributesForDisappearingSupplementaryElementOfKind(elementKind: String, atIndexPath elementIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {


    guard elementKind == CSStickyHeaderParallaxHeader,
          let attributes = self.layoutAttributesForSupplementaryViewOfKind(
            elementKind, atIndexPath: elementIndexPath) as? CSStickyHeaderFlowLayoutAttributes
          else {
            return super.finalLayoutAttributesForDisappearingSupplementaryElementOfKind(elementKind, atIndexPath: elementIndexPath)
    }

    updateParallaxHeaderAttributes(attributes)

    return attributes
  }

  public override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {

    let attributes =
      super.layoutAttributesForSupplementaryViewOfKind(elementKind,
                                                       atIndexPath: indexPath)

    guard elementKind == CSStickyHeaderParallaxHeader &&
          attributes != nil else { return attributes }

    return CSStickyHeaderFlowLayoutAttributes(forSupplementaryViewOfKind: elementKind,
                                              withIndexPath: indexPath)

  }

  public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

    if collectionView?.dataSource == nil {
      print("collection view has no datasource")
      return nil
    }

    let adjustedOrigin = CGPoint(
      x: rect.origin.x,
      y: rect.origin.y - parallaxHeaderReferenceSize.height)

    let adjustedRect = CGRect(
      origin: adjustedOrigin,
      size: rect.size)

    guard let originalAttributes = super.layoutAttributesForElementsInRect(adjustedRect) else {
      return nil
    }

    var headers = [Int : UICollectionViewLayoutAttributes]()
    var lastCells = [Int : UICollectionViewLayoutAttributes]()
    var visibleParallaxHeader = false

    var allItems = originalAttributes
      .flatMap {
        $0.copy() as? UICollectionViewLayoutAttributes
      }

    allItems.forEach { [unowned self] (attributes) in
      let origin = CGPoint(
        x: attributes.frame.origin.x,
        y: attributes.frame.origin.y + self.parallaxHeaderReferenceSize.height)

      let frame = CGRect(
        origin: origin,
        size: attributes.frame.size)

      attributes.frame = frame

      let indexPath = attributes.indexPath
      let isHeader =
        attributes.representedElementKind == UICollectionElementKindSectionHeader
      let isFooter =
        attributes.representedElementKind == UICollectionElementKindSectionFooter

      if isHeader {
        headers[indexPath.section] = attributes
        attributes.zIndex = 1024
      }
      else if isFooter {
        // Not handled
        attributes.zIndex = 1
      }
      else {
        attributes.zIndex = 1
        if let currentAttribute = lastCells[indexPath.section] where indexPath.row > currentAttribute.indexPath.row {
          lastCells[indexPath.section] = attributes
        } else {
          lastCells[indexPath.section] = attributes
        }

        if indexPath.item == 0 && indexPath.section == 0 {
          visibleParallaxHeader = true
        }
      }
    }

    if CGRectGetMinY(rect) <= 0 || parallaxHeaderAlwaysOnTop {
      visibleParallaxHeader = true
    }

    if visibleParallaxHeader && CGSizeEqualToSize(.zero, self.parallaxHeaderReferenceSize) {
      let currentAttributes = CSStickyHeaderFlowLayoutAttributes(forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withIndexPath: NSIndexPath(index: 0))

      updateParallaxHeaderAttributes(currentAttributes)
      allItems.append(currentAttributes)
    }

    if self.disableStickyHeaders == false {
      lastCells.forEach({ (key, val) in
        let indexPath = val.indexPath
        let indexPathKey = indexPath.section
        if let header = headers[indexPathKey] {
          if !CGSizeEqualToSize(.zero, header.frame.size) {
            self.updateHeaderAttributes(header, lastCellAttributes: lastCells[indexPathKey])
          }
        } else {
          if let header = self.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: NSIndexPath(forItem: 0, inSection: indexPath.section)) {
            if !CGSizeEqualToSize(.zero, header.frame.size) {
              allItems.append(header)
            }
          }
        }
      })
    }

    return allItems
  }

  public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
    guard let attributes = super.layoutAttributesForItemAtIndexPath(indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
      print("not attributes")
      return nil
    }

    attributes.frame = CGRect(
      origin: CGPoint(x: attributes.frame.origin.x, y: attributes.frame.origin.y + self.parallaxHeaderReferenceSize.height),
      size: attributes.frame.size
    )

    return attributes
  }

  public override func collectionViewContentSize() -> CGSize {
    guard self.collectionView?.superview != nil else {
      print("no size")
      return .zero
    }

    let size = super.collectionViewContentSize()
    return CGSize(width: size.width, height: size.height + self.parallaxHeaderReferenceSize.height)
  }

  public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
    return true
  }

  private func updateHeaderAttributes(attributes: UICollectionViewLayoutAttributes, lastCellAttributes: UICollectionViewLayoutAttributes?) {

    guard let lastCellAttributes = lastCellAttributes, let collectionView = self.collectionView else {
      print ("no last cell")
      return
    }

    let currentBounds = collectionView.bounds
    attributes.zIndex = 1024
    attributes.hidden = false

    var origin = attributes.frame.origin
    let sectionMaxY = CGRectGetMaxY(lastCellAttributes.frame) - attributes.frame.size.height
    var y = CGRectGetMaxY(currentBounds) - currentBounds.size.height - collectionView.contentInset.top

    if self.parallaxHeaderAlwaysOnTop {
      y += parallaxHeaderMinimumReferenceSize.height
    }

    let maxY = min(max(y, attributes.frame.origin.y), sectionMaxY)

    origin.y = maxY

    attributes.frame = CGRect(origin: origin, size: attributes.frame.size)
  }

  private func updateParallaxHeaderAttributes(attributes: CSStickyHeaderFlowLayoutAttributes) {

    guard let collectionView = self.collectionView else {
      return
    }

    var frame = attributes.frame
    frame.size = parallaxHeaderReferenceSize
    let bounds = collectionView.bounds
    let maxY = CGRectGetMaxY(frame)

    var y = min(maxY - self.parallaxHeaderMinimumReferenceSize.height, bounds.origin.y + collectionView.contentInset.top)

    let height = max(0, -y + maxY)

    let maxHeight = parallaxHeaderReferenceSize.height
    let minHeight = parallaxHeaderMinimumReferenceSize.height

    attributes.progressiveness = (height - minHeight) / (maxHeight - minHeight)
    attributes.zIndex = 0

    if self.parallaxHeaderAlwaysOnTop && height <= parallaxHeaderMinimumReferenceSize.height {
      let insetTop = collectionView.contentInset.top
      y = collectionView.contentOffset.y + insetTop
      attributes.zIndex = 2000
    }

    attributes.frame = CGRect(
      x: frame.origin.x,
      y: y,
      width: frame.size.width,
      height: self.disableStickyHeaders && height > maxHeight ? maxHeight : height)
  }

}
