//
//  ContentSizeTableView.swift
//  iTunesApp
//
//  Created by Daria on 11.04.2024.
//

import UIKit

final class ContentSizeTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize{
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
    
}
