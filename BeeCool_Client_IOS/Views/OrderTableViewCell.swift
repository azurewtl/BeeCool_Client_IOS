//
//  OrderTableViewCell.swift
//  BeeCool_Client_IOS
//
//  Created by caiyang on 15/2/5.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!

    @IBOutlet var resultLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    
    var topLine = UIView()
    var bottomLine = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.addSubview(topLine)
        self.contentView.addSubview(bottomLine)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        topLine.backgroundColor = UIColor.grayColor()
        bottomLine.backgroundColor = UIColor.grayColor()
        topLine.frame = CGRectMake(0, nameLabel.frame.height + 5, contentView.frame.width, 1)
        bottomLine.frame = CGRectMake(0, timeLabel.frame.origin.y - 2, contentView.frame.width, 1)
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
