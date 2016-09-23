//
//  CSStickyHeaderFlowLayout.swift
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by Christian Enevoldsen on 13/09/16.
//  Copyright © 2016 Jamz Tang. All rights reserved.
//

import UIKit

public let CSStickyHeaderParallaxHeader = "CSStickyHeaderParallaxHeader"

open class CSStickyHeaderFlowLayout: UICollectionViewFlowLayout {

  // MARK: Properties

  open var parallaxHeaderReferenceSize = CGSize.zero {
    didSet { invalidateLayout() }
  }

  open var parallaxHeaderMinimumReferenceSize = CGSize.zero
  open var parallaxHeaderAlwaysOnTop = false
  open var disableStickyHeaders = false
  open var disableStretching = false

  // MARK: Expose Kind Name for ObjC
  
  open static func elementKindStickyHeaderParallaxHeader() -> String {
    return CSStickyHeaderParallaxHeader
  }
  
  // MARK: Layout Attributes

  open override func initialLayoutAttributesForAppearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    guard let attributes = super.initialLayoutAttributesForAppearingSupplementaryElement(ofKind: elementKind, at: elementIndexPath) else { return nil }

    if elementKind != CSStickyHeaderParallaxHeader {
      var frame = attributes.frame
      frame.origin.y += parallaxHeaderReferenceSize.height
      
      attributes.frame = frame
    }

    return attributes
  }

  open override func finalLayoutAttributesForDisappearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    guard
      let attributes = layoutAttributesForSupplementaryView(ofKind: elementKind, at: elementIndexPath) as? CSStickyHeaderFlowLayoutAttributes,
      elementKind != CSStickyHeaderParallaxHeader
    else {
      return super.finalLayoutAttributesForDisappearingSupplementaryElement(ofKind: elementKind, at: elementIndexPath)
    }

    updateParallaxHeaderAttributes(attributes)
    
    return attributes
  }

  open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    guard let attributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath) else {
      
      if elementKind == CSStickyHeaderParallaxHeader {
        return CSStickyHeaderFlowLayoutAttributes(forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, with: indexPath)
      } else {
        return nil
      }
    }
    
    return attributes

  }

  open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    let adjustedRect = rect.offsetBy(dx: 0, dy: -parallaxHeaderReferenceSize.height)
    
    guard let _ = collectionView, let originalAttributes = super.layoutAttributesForElements(in: adjustedRect) else { return nil }

    var retVal = [IndexPath: UICollectionViewLayoutAttributes]()
    var parallaxHeaderOnScreen = false

    let allItems = originalAttributes.flatMap {
      $0.copy() as? UICollectionViewLayoutAttributes
    }

    var visibleHeaders = allItems.filter {
      $0.representedElementKind == UICollectionElementKindSectionHeader
    }

    let visibleCells = allItems.filter {
      $0.representedElementCategory == .cell
    }

    let otherVisibleItems = allItems.filter {
      return $0.representedElementKind == UICollectionElementKindSectionFooter || $0.representedElementCategory == .decorationView
    }

    (visibleHeaders + visibleCells).forEach {
      $0.frame = $0.frame.offsetBy(dx: 0, dy: self.parallaxHeaderReferenceSize.height)
    }

    let lastCells = visibleCells
      .reduce([Int : UICollectionViewLayoutAttributes]()) { (prev, cur) in
        var res = prev
        if let last = prev[cur.indexPath.section] {
          if last.indexPath.row < cur.indexPath.row && last.indexPath.section == cur.indexPath.section {
            res[cur.indexPath.section] = cur
          }
        } else {
          res[cur.indexPath.section] = cur
        }
        return res
      }

    parallaxHeaderOnScreen = rect.minY <= 0 || parallaxHeaderAlwaysOnTop

    visibleHeaders.forEach { $0.zIndex = 1024 }

    visibleCells.forEach { $0.zIndex = 1 }

    if parallaxHeaderOnScreen && !CGSize.zero.equalTo(self.parallaxHeaderReferenceSize) {
      let currentAttributes = CSStickyHeaderFlowLayoutAttributes(forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, with: IndexPath(index: 0))
      updateParallaxHeaderAttributes(currentAttributes)

      retVal[currentAttributes.indexPath] = currentAttributes
    }

    if !disableStickyHeaders {
      visibleHeaders = visibleHeaders.flatMap { (header) in
        guard let lastCell = lastCells[header.indexPath.section] else {
          return nil
        }
        
        return self.getAdjustedHeaderAttributesForLastCell(header, lastCellAttributes: lastCell)
      }
    }


    return Array(retVal.values) + visibleCells + visibleHeaders + otherVisibleItems
  }

  open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    guard let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
      return nil
    }

    attributes.frame = CGRect(
      origin: CGPoint(x: attributes.frame.origin.x, y: attributes.frame.origin.y + self.parallaxHeaderReferenceSize.height),
      size: attributes.frame.size
    )

    return attributes
  }

  open override var collectionViewContentSize : CGSize {
    guard let _ = self.collectionView?.superview else {
      return .zero
    }

    let size = super.collectionViewContentSize
    return CGSize(width: size.width, height: size.height + self.parallaxHeaderReferenceSize.height)
  }

  open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }

  // MARK: Private Methods
  
  fileprivate func getAdjustedHeaderAttributesForLastCell(_ attributes: UICollectionViewLayoutAttributes, lastCellAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes? {
    guard let collectionView = self.collectionView, let newAttributes = attributes.copy() as? UICollectionViewLayoutAttributes else {
      return nil
    }

    let currentBounds = collectionView.bounds

    var origin = attributes.frame.origin
    let sectionMaxY = lastCellAttributes.frame.maxY - attributes.frame.size.height
    var y = currentBounds.maxY - currentBounds.size.height + collectionView.contentInset.top

    if self.parallaxHeaderAlwaysOnTop {
      y += parallaxHeaderMinimumReferenceSize.height
    }

    origin.y = min(max(y, attributes.frame.origin.y), sectionMaxY)

    newAttributes.isHidden = false
    newAttributes.frame = CGRect(origin: origin, size: attributes.frame.size)

    return newAttributes
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

  // MARK: Overrides

  open override class var layoutAttributesClass : AnyClass {
    return CSStickyHeaderFlowLayoutAttributes.self
  }
}
