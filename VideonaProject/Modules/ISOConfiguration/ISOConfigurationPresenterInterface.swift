//
//  ISOConfigurationPresenterInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

protocol ISOConfigurationPresenterInterface {
    func autoISOPushed()
    func fiftyISOPushed()
    func oneHundredISOPushed()
    func twoHundredISOPushed()
    func fourHundredISOPushed()
    func maxISOPushed()
}

protocol ISOConfigurationPresenterDelegate {
    func deselectAllButtons()
    func selectAutoButton()
    func selectFiftyButton()
    func selectOneHundredButton()
    func selectTwoHundredButton()
    func selectFourHundredButton()
    func selectMaxButton()
}
