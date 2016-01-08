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

        self.backgroundColor = UIColor.whiteColor()
        
        let bounds = CGRectMake(0, 0, CGRectGetMaxX(frame), CGRectGetMaxY(frame))
        let label = UILabel(frame: bounds)
        label.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
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
