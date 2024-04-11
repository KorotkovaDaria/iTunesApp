//
//  UIHelper.swift
//  iTunesApp
//
//  Created by Daria on 09.04.2024.
//

import Foundation
import UIKit

struct UIHelper {
    static func createTwoColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width                       = view.bounds.width
        let padding: CGFloat            = 2
        let minimumItemSpacing: CGFloat = 10
        let numberOfColumns             = 2
        
        let availableWidth = width - (padding * CGFloat(numberOfColumns + 1)) - (minimumItemSpacing * CGFloat(numberOfColumns - 1))
        let itemWidth      = availableWidth / CGFloat(numberOfColumns)
        
        let flowLayout                     = UICollectionViewFlowLayout()
        flowLayout.sectionInset            = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.minimumInteritemSpacing = minimumItemSpacing
        flowLayout.minimumLineSpacing      = minimumItemSpacing
        flowLayout.itemSize                = CGSize(width: itemWidth, height: itemWidth + 30)
        
        return flowLayout
    }
}
