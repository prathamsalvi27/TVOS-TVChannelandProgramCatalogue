//
//  ChannelTableViewCell.swift
//  Vmedia
//
//  Created by Prathamesh Salvi on 28/04/23.
//

import UIKit

class ChannelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelChannelNo: UILabel!
    @IBOutlet weak var labelChannelName: UILabel!
    
    func setUpCell(data: Channel) {
        labelChannelNo.text = data.orderNum.description
        labelChannelName.text = data.CallSign
    }
}
