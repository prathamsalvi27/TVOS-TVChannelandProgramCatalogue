//
//  ProgramItemCollectionViewLayout.swift
//  Vmedia
//
//  Created by Prathamesh Salvi on 29/04/23.
//

import Foundation
import UIKit

class ProgramItemCollectionViewLayout: UICollectionViewLayout {
    
    // Default Values for HEIGHT and WIDTH
    let CELL_HEIGHT = 114.0
    let CELL_WIDTH = 100.0
    var cellAttrsDictionary = Dictionary<IndexPath, UICollectionViewLayoutAttributes>()
    
    var contentSize = CGSize.zero
    var programData: [TVProgramData] = []
    
    
    override var collectionViewContentSize: CGSize {
        return self.contentSize
    }
    
    override func prepare() {
        if (collectionView?.numberOfSections ?? 0) > 0 {
            for section in 0..<(collectionView?.numberOfSections ?? 0) - 1 {
                var dynamicCellWidth: Double = 0
                for item in 0...(collectionView?.numberOfItems(inSection: section) ?? 0) - 1 {
                    // Build the UICollectionVieLayoutAttributes for the cell.
                    var cellWidth: Double = 0
                    if !self.programData.isEmpty {
                        cellWidth = self.programData[section].programItems[item].cellWidth
                    }
                    let cellIndex = IndexPath(item: item, section: section)
                    let xPos = dynamicCellWidth
                    let yPos = Double(section) * CELL_HEIGHT
                    dynamicCellWidth += cellWidth
                    
                    let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex)
                    cellAttributes.frame = CGRect(x: xPos, y: yPos, width: cellWidth, height: CELL_HEIGHT)
                    
                    // Determine zIndex based on cell type.
                    if section == 0 && item == 0 {
                        cellAttributes.zIndex = 4
                    } else if section == 0 {
                        cellAttributes.zIndex = 3
                    } else if item == 0 {
                        cellAttributes.zIndex = 2
                    } else {
                        cellAttributes.zIndex = 1
                    }
                    
                    cellAttrsDictionary[cellIndex] = cellAttributes
                }
                
            }
        }
        
        let contentWidth: Double = 14400
        let contentHeight = Double(collectionView!.numberOfSections) * CELL_HEIGHT
        self.contentSize = CGSize(width: contentWidth, height: contentHeight)
    }
        
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // Create an array to hold all elements found in our current view.
        var attributesInRect = [UICollectionViewLayoutAttributes]()
        for cellAttributes in cellAttrsDictionary.values {
            if CGRectIntersectsRect(rect, cellAttributes.frame) {
                attributesInRect.append(cellAttributes)
            }
        }
        // Return list of elements.
        return attributesInRect
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttrsDictionary[indexPath]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
    
}
