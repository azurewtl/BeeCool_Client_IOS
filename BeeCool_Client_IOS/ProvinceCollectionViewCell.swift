//
//  ProvinceCollectionViewCell.swift
//  BeeCool_Client_IOS
//
//  Created by caiyang on 14/12/19.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

import UIKit

class ProvinceCollectionViewCell: UICollectionViewCell {
    var label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.frame = self.contentView.frame
        label.textAlignment = NSTextAlignment.Center
        self.contentView.addSubview(label)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
}
