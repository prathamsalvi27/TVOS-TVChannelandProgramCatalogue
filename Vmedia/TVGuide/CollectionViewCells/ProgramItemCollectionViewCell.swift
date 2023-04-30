//
//  ProgramItemCollectionViewCell.swift
//  Vmedia
//
//  Created by Prathamesh Salvi on 29/04/23.
//

import UIKit

struct ProgramItemVm {
    let programItem: ProgramItem?
    let name: String
    let lengthInSec: Int
    let unFocusedColor: UIColor = UIColor(red: 11.0 / 255.0 , green: 2.0 / 255.0, blue: 32.0 / 255.0, alpha: 1.0)
    let focusedColor: UIColor = UIColor(red: 22.0 / 255.0, green: 161.0 / 255.0, blue: 253.0 / 255.0, alpha: 1.0)
    var cellWidth: Double {
        // Size of 30 mins cell slot is 300
        // 1 min is 10
        let minDuration = lengthInSec / 60
        return Double(minDuration * 10)
    }
}

class ProgramItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var labelProgramName: UILabel!
    @IBOutlet weak var programTime: UILabel!
    
    @IBOutlet weak var viewContainer: UIView!
    func setUpCell(data: ProgramItemVm, isFocussed: Bool) {
        if data.name.isEmpty {
            labelProgramName.text = "-- // -- // --"
        } else {
            labelProgramName.text = data.name
        }
        
        if isFocussed {
            self.programTime.isHidden = false
            self.programTime.text = data.programItem?.startHourAndMin
            print(":::: color ::: \(data.focusedColor)")
            self.viewContainer.backgroundColor = data.focusedColor
        } else {
            self.programTime.isHidden = true
            self.viewContainer.backgroundColor = data.unFocusedColor
            print(":::: color ::: \(data.unFocusedColor)")
        }
        
    }
    
}
