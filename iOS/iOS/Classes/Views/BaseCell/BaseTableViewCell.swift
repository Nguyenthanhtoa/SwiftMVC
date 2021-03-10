//
//  BaseTableViewCell.swift
//  BnailsStaffs
//
//  Created by ToaNT1 on 1/27/18.
//  Copyright © 2018 ThanhToa. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let bgView = UIView(frame: contentView.frame)
//        bgView.backgroundColor = .contentBgColor
        selectedBackgroundView = bgView
    }

}
