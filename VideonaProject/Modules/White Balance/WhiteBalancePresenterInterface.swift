//
//  WhiteBalancePresenterInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

protocol WhiteBalancePresenterInterface {
    func autoPushed()
    func cloudyPushed()
    func daylightPushed()
    func flashPushed()
    func fluorescentPushed()
    func tungstenPushed()
}

protocol WhiteBalancePresenterDelegate {
    func deselectAllButtons()
    func selectAutoButton()
    func selectCloudyButton()
    func selectDaylightButton()
    func selectFlashButton()
    func selectTungstenButton()
    func selectFluorescentButton()
}
