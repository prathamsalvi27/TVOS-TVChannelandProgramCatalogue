//
//  HelperExtensions.swift
//  Vmedia
//
//  Created by Prathamesh Salvi on 28/04/23.
//

import Foundation
import UIKit

// Table View
extension UITableView {
    // Identifier & Nib name should be same for this method
    func registerCellWithIdentifier(_ identifier: String) {
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forCellReuseIdentifier: identifier)
    }
}

extension UITableViewCell {
    @objc class var identifier: String {
        return String(describing: self)
    }
}

// Collection View

extension UICollectionView {
    // Identifier & Nib name should be same for this method
    func registerCellWithIdentifier(_ identifier: String) {
        register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }

    // Identifier & Nib name should be same for this method
    func registerHeaderWithIdentifier(_ identifier: String) {
        register(UINib(nibName: identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
    }
}

extension UICollectionViewCell {
    @objc class var identifier: String {
        return String(describing: self)
    }
}
