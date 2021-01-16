//
//  UIHelper.swift
//  MovieReviewApp
//
//  Created by Amer Abboud on 1/7/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import UIKit

struct UIHelper {
    
    static func createFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding = CGFloat(12)
        let minimumItemSpacing = CGFloat(10)
        let availableWidth = width - 2 * padding - 2 * minimumItemSpacing
        let itemWidth = availableWidth / 2
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: 1.5*itemWidth + 40)
        
        return flowLayout
    }
}
