//
//  CSStickyHeaderFlowLayoutAttributes.swift
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by Christian Enevoldsen on 13/09/16.
//  Copyright © 2016 Jamz Tang. All rights reserved.
//

import UIKit

open class CSStickyHeaderFlowLayoutAttributes: UICollectionViewLayoutAttributes {

  open var progressiveness = CGFloat(0)

  open override func copy(with zone: NSZone?) -> Any {
    let copy = super.copy(with: zone)
    guard let typedCopy = copy as? CSStickyHeaderFlowLayoutAttributes else {
      return copy
    }

    typedCopy.progressiveness = self.progressiveness
    return typedCopy
  }

  open override var zIndex: Int {
    didSet {
      self.transform3D = CATransform3DMakeTranslation(0, 0, zIndex == 1 ? -1 : 0)
    }
  }
}
