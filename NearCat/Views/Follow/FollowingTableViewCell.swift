//
//  FollowingTableViewCell.swift
//  NearCat
//
//  Created by huchunbo on 16/1/13.
//  Copyright © 2016年 Bijiabo. All rights reserved.
//

import UIKit

class FollowingTableViewCell: UITableViewCell, CustomSeparatorCell {

    @IBOutlet weak var avatarImageView: AvatarImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var separatorLineView: UIView!
    
    var id: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        separatorLineView.backgroundColor = Constant.Color.TableViewSeparator
        extension_setDefaultSelectedColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    var userName: String = String() {
        didSet {
            userNameLabel.text = userName
        }
    }
    
    var displaySeparatorLine: Bool = true {
        didSet {
            separatorLineView.hidden = !displaySeparatorLine
        }
    }
}
