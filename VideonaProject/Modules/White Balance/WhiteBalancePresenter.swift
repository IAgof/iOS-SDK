//
//  WhiteBalancePresenter.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

open class WhiteBalancePresenter: WhiteBalancePresenterInterface, WhiteBalanceInteractorDelegate {
    //MARK : VIPER
    var delegate: WhiteBalancePresenterDelegate
    var interactor: WhiteBalanceInteractorInterface?

    init(controller: WhiteBalanceView) {
        delegate = controller
        interactor = WhiteBalanceInteractor(presenter: self)
    }

    // MARK: Interface
    func autoPushed() {
        interactor?.setWBToDevice(WhiteBalanceGain.auto)

        delegate.deselectAllButtons()
        delegate.selectAutoButton()
    }

    func cloudyPushed() {
        interactor?.setWBToDevice(WhiteBalanceGain.cloudy)

        delegate.deselectAllButtons()
        delegate.selectCloudyButton()
    }

    func daylightPushed() {
        interactor?.setWBToDevice(WhiteBalanceGain.daylight)

        delegate.deselectAllButtons()
        delegate.selectDaylightButton()
    }

    func flashPushed() {
        interactor?.setWBToDevice(WhiteBalanceGain.flash)

        delegate.deselectAllButtons()
        delegate.selectFlashButton()
    }

    func fluorescentPushed() {
        interactor?.setWBToDevice(WhiteBalanceGain.fluorescent)

        delegate.deselectAllButtons()
        delegate.selectFluorescentButton()
    }

    func tungstenPushed() {
        interactor?.setWBToDevice(WhiteBalanceGain.tungsten)

        delegate.deselectAllButtons()
        delegate.selectTungstenButton()
    }
    // MARK: Interactor Delegate

}
