//
//  ISOConfigurationPresenter.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

open class ISOConfigurationPresenter: ISOConfigurationPresenterInterface, ISOConfigurationInteractorDelegate {
    //MARK : VIPER
    var delegate: ISOConfigurationPresenterDelegate
    var interactor: ISOConfigurationInteractorInterface?

    init(controller: ISOConfigurationView) {
        delegate = controller
        interactor = ISOConfigurationInteractor(presenter: self)
    }

    // MARK: Interface
    func autoISOPushed() {
        interactor?.setISOToDevice(-1)

        delegate.deselectAllButtons()
        delegate.selectAutoButton()
    }

    func fiftyISOPushed() {
        interactor?.setISOToDevice(50)

        delegate.deselectAllButtons()
        delegate.selectFiftyButton()
    }

    func oneHundredISOPushed() {
        interactor?.setISOToDevice(100)

        delegate.deselectAllButtons()
        delegate.selectOneHundredButton()
    }

    func twoHundredISOPushed() {
        interactor?.setISOToDevice(200)

        delegate.deselectAllButtons()
        delegate.selectTwoHundredButton()
    }

    func fourHundredISOPushed() {
        interactor?.setISOToDevice(400)

        delegate.deselectAllButtons()
        delegate.selectFourHundredButton()
    }

    func maxISOPushed() {
        interactor?.setISOToDevice(800)

        delegate.deselectAllButtons()
        delegate.selectMaxButton()
    }

    // MARK: Interactor Delegate

}
