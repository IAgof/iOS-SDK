//
//  SpaceOnDiskPresenterInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

protocol SpaceOnDiskPresenterInterface{
    func updateSpaceLeftLevel()
}

protocol SpaceOnDiskPresenterDelegate{
    func updateBarValue(_ value: CGFloat)
    func updateBarColor(_ color:UIColor)
    func updateTextSpaceLeft(_ text:String)
}
