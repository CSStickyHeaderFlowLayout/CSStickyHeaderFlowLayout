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

open class CSStickyHeaderFlowLayout: UICollectionViewFlowLayout {

  open override func invalidateLayout() {
    if #available(iOS 10, *) {
      self.collectionView?.isPrefetchingEnabled = false
    }

    super.invalidateLayout()
  }

  open var parallaxHeaderReferenceSize = CGSize.zero {
    didSet {
      invalidateLayout()
    }
  }
  open var parallaxHeaderMinimumReferenceSize = CGSize.zero
  open var parallaxHeaderAlwaysOnTop = false
  open var disableStickyHeaders = false
  open var disableStretching = false

  open override class var layoutAttributesClass : AnyClass {
    return CSStickyHeaderFlowLayoutAttributes.self
  }

  open override func initialLayoutAttributesForAppearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

    let attributes = super.initialLayoutAttributesForAppearingSupplementaryElement(ofKind: elementKind, at: elementIndexPath)

    if elementKind == CSStickyHeaderParallaxHeader {
      return nil
    }

    var frame = attributes?.frame ?? .zero
    frame.origin.y += parallaxHeaderReferenceSize.height
    attributes?.frame = frame

    return attributes
  }

  open override func finalLayoutAttributesForDisappearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

    if elementKind == CSStickyHeaderParallaxHeader {
      if let attributes = layoutAttributesForSupplementaryView(ofKind: elementKind, at: elementIndexPath) as? CSStickyHeaderFlowLayoutAttributes {
        updateParallaxHeaderAttributes(attributes)
        return attributes
      }
    }

    return super.finalLayoutAttributesForDisappearingSupplementaryElement(ofKind: elementKind, at: elementIndexPath)
  }

  open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

    var attributes =
      super.layoutAttributesForSupplementaryView(ofKind: elementKind,
                                                       at: indexPath)

    if ((attributes == nil) && elementKind == CSStickyHeaderParallaxHeader) {
      attributes = CSStickyHeaderFlowLayoutAttributes(forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, with: indexPath)
    }

    return attributes

  }

  open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

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

    guard let originalAttributes = super.layoutAttributesForElements(in: adjustedRect) else {
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
        headers[(indexPath as NSIndexPath).section] = attributes
        attributes.zIndex = 1024
      }
      else if isFooter {
        // Not handled
        attributes.zIndex = 1
      }
      else {
        attributes.zIndex = 1
        if let currentAttribute = lastCells[(indexPath as NSIndexPath).section] , (indexPath as NSIndexPath).row > (currentAttribute.indexPath as NSIndexPath).row {
          lastCells[(indexPath as NSIndexPath).section] = attributes
        } else {
          lastCells[(indexPath as NSIndexPath).section] = attributes
        }

        if (indexPath as NSIndexPath).item == 0 && (indexPath as NSIndexPath).section == 0 {
          visibleParallaxHeader = true
        }
      }
    }

    if rect.minY <= 0 || parallaxHeaderAlwaysOnTop {
      visibleParallaxHeader = true
    }

    if visibleParallaxHeader && !CGSize.zero.equalTo(self.parallaxHeaderReferenceSize) {
      let currentAttributes = CSStickyHeaderFlowLayoutAttributes(forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, with: IndexPath(index: 0))

      updateParallaxHeaderAttributes(currentAttributes)
      allItems.append(currentAttributes)
    }

    if self.disableStickyHeaders == false {
      lastCells.forEach({ (key, val) in
        let indexPath = val.indexPath
        let indexPathKey = (indexPath as NSIndexPath).section

        var header = headers[indexPathKey]
        if header == nil {
          if let header = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: indexPath) {
            if !CGSize.zero.equalTo(header.frame.size) {
              allItems.append(header)
            }
          }
        }
        if let header = header {

          if !CGSize.zero.equalTo(header.frame.size) {
            updateHeaderAttributes(header, lastCellAttributes: lastCells[indexPathKey])
          }
        }
      })
    }

    return allItems
  }

  open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    guard let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
      print("not attributes")
      return nil
    }

    attributes.frame = CGRect(
      origin: CGPoint(x: attributes.frame.origin.x, y: attributes.frame.origin.y + self.parallaxHeaderReferenceSize.height),
      size: attributes.frame.size
    )

    return attributes
  }

  open override var collectionViewContentSize : CGSize {
    guard self.collectionView?.superview != nil else {
      print("no size")
      return .zero
    }

    let size = super.collectionViewContentSize
    return CGSize(width: size.width, height: size.height + self.parallaxHeaderReferenceSize.height)
  }

  open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }

  fileprivate func updateHeaderAttributes(_ attributes: UICollectionViewLayoutAttributes, lastCellAttributes: UICollectionViewLayoutAttributes?) {

    guard let lastCellAttributes = lastCellAttributes, let collectionView = self.collectionView else {
      print ("no last cell")
      return
    }

    let currentBounds = collectionView.bounds
    attributes.zIndex = 1024
    attributes.isHidden = false

    var origin = attributes.frame.origin
    let sectionMaxY = lastCellAttributes.frame.maxY - attributes.frame.size.height
    var y = currentBounds.maxY - currentBounds.size.height + collectionView.contentInset.top

    if self.parallaxHeaderAlwaysOnTop {
      y += parallaxHeaderMinimumReferenceSize.height
    }

    let maxY = min(max(y, attributes.frame.origin.y), sectionMaxY)

    origin.y = maxY

    attributes.frame = CGRect(origin: origin, size: attributes.frame.size)
  }

  fileprivate func updateParallaxHeaderAttributes(_ attributes: CSStickyHeaderFlowLayoutAttributes) {

    guard let collectionView = self.collectionView else {
      return
    }

    var frame = attributes.frame
    frame.size = parallaxHeaderReferenceSize
    let bounds = collectionView.bounds
    let maxY = frame.maxY

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
      height: self.disableStretching && height > maxHeight ? maxHeight : height)
  }

}
