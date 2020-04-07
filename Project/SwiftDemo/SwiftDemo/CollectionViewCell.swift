//
//  CollectionViewCell.swift
//  SwiftDemo
//
//  Created by James Tang on 16/7/15.
//  Copyright © 2015 James Tang. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    var text : String? {
        didSet {
            self.reloadData()
        }
    }

    private var textLabel : UILabel?

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.white
        
        let bounds = CGRect(x: 0, y: 0, width: frame.maxX, height: frame.maxY)
        let label = UILabel(frame: bounds)
        label.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth]
        self.textLabel = label
        self.addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func reloadData() {
        self.textLabel?.text = self.text
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel?.frame = self.bounds
    }
}
