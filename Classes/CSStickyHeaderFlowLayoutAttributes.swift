//
//  CSStickyHeaderFlowLayoutAttributes.swift
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by Christian Enevoldsen on 13/09/16.
//  Copyright © 2016 Jamz Tang. All rights reserved.
//

import UIKit

public class CSStickyHeaderFlowLayoutAttributes: UICollectionViewLayoutAttributes {

  public var progressiveness = CGFloat(0)

  public override func copyWithZone(zone: NSZone) -> AnyObject {
    let copy = super.copyWithZone(zone)
    guard let typedCopy = copy as? CSStickyHeaderFlowLayoutAttributes else {
      return copy
    }

    typedCopy.progressiveness = self.progressiveness
    return typedCopy
  }

  public override var zIndex: Int {
    didSet {
      self.transform3D = CATransform3DMakeTranslation(0, 0, zIndex == 1 ? -1 : 0)
    }
  }
}
