//
//  ResolutionsSelectorInteractorInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

protocol ResolutionsSelectorInteractorInterface{
    func getResolutions()
    func findInitResolutionInList(_ resolution:String)
    func setResolutionToDevice(_ resolutionPositionActive:Int)
}

protocol ResolutionsSelectorInteractorDelegate{
    func setResolutionsTitle(_ titleList:[String])
    func setActiveResolution(_ position:Int)
    func retrieveAVResolutionPresset(_ resolution:String)
}
