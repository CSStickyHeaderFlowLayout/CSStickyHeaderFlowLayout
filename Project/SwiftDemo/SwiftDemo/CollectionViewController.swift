//
//  ViewController.swift
//  SwiftDemo
//
//  Created by James Tang on 16/7/15.
//  Copyright (c) 2015 James Tang. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {

    var items : [String] = ["CSStickyHeaderFlowLayout basic example", "Example to initialize in code", "As well as in Swift", "Please Enjoy"]

    private var layout : CSStickyHeaderFlowLayout? {
        return self.collectionView?.collectionViewLayout as? CSStickyHeaderFlowLayout
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.alwaysBounceVertical = true
        self.view.backgroundColor = UIColor.whiteColor()

        // Setup Cell
        self.collectionView?.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.layout?.itemSize = CGSizeMake(self.view.frame.size.width, 44)

        // Setup Header
        self.collectionView?.registerClass(CollectionParallaxHeader.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: "parallaxHeader")
        self.layout?.parallaxHeaderReferenceSize = CGSizeMake(self.view.frame.size.width, 100)

        // Setup Section Header
        self.collectionView?.registerClass(CollectionViewSectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "sectionHeader")
        self.layout?.headerReferenceSize = CGSizeMake(320, 40)
    }

    // Cells

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        cell.text = self.items[indexPath.row]
        return cell
    }

    // Parallax Header

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        if kind == CSStickyHeaderParallaxHeader {
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "parallaxHeader", forIndexPath: indexPath)
            return view
        } else if kind == UICollectionElementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "sectionHeader", forIndexPath: indexPath)
            view.backgroundColor = UIColor.lightGrayColor()
            return view
        }

        return UICollectionReusableView()

    }

}

