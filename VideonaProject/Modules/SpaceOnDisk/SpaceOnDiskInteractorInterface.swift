//
//  SpaceOnDiskInteractorInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

protocol SpaceOnDiskInteractorInterface{
    func getSpaceOnDiskValues()
}

protocol SpaceOnDiskInteractorDelegate{
    func setPercentValue(_ level:Float)
    func setFreeMemory(freeMemory:String)
}
