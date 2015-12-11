//
//  CollectionViewSectionHeader.swift
//  SwiftDemo
//
//  Created by James Tang on 23/7/15.
//  Copyright © 2015 James Tang. All rights reserved.
//

import UIKit

class CollectionViewSectionHeader: UICollectionReusableView {

    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        self.addSubview(label)
        label.frame = self.bounds
        label.text = UICollectionElementKindSectionHeader
    }
}
