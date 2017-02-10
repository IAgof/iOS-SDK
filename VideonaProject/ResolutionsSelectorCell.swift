//
//  ResolutionsSelectorCell.swift
//  ResolutionsSelector
//
//  Created by Alejandro Arjonilla Garcia on 15/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

class ResolutionsSelectorCell: UITableViewCell {
    
    @IBOutlet weak var resolutionsLabel: UILabel?
    @IBOutlet weak var resolutionsSwitch: UISwitch?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        
        let backView = UIView.init(frame: self.frame)
        backView.backgroundColor = UIColor.clear
        self.selectedBackgroundView = backView
        self.backgroundView = backView
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
}
