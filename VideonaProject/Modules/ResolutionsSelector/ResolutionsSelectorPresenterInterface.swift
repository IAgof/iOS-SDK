//
//  ResolutionsSelectorPresenterInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

protocol ResolutionsSelectorPresenterInterface {
    func getResolutions()
    func setResolutionAtInitEvent(_ resolution: String)
    func switchResolutionStateChanged(_ position: Int)
    func accepButtonEvent()
}

protocol ResolutionsSelectorPresenterDelegate {
    func setResolutionsTableList(_ list: [String])
    func setResolutionSwitchState(_ position: Int,
                                  state: Bool)
    func sendAVResolutionPressetToThirdParty(_ resolution: String)
}
