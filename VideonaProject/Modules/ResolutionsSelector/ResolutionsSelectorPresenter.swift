//
//  ResolutionsSelectorPresenter.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

open class ResolutionsSelectorPresenter: ResolutionsSelectorPresenterInterface, ResolutionsSelectorInteractorDelegate {
    //MARK : VIPER
    var delegate: ResolutionsSelectorPresenterDelegate
    var interactor: ResolutionsSelectorInteractorInterface?

    var resolutionPositionActive = -1

    init(controller: ResolutionsSelectorView) {
        delegate = controller
        interactor = ResolutionsSelectorInteractor(presenter: self)
    }

    func getResolutions() {
        interactor?.getResolutions()
    }

    func setResolutionAtInitEvent(_ resolution: String) {
        interactor?.findInitResolutionInList(resolution)
    }

    func switchResolutionStateChanged(_ position: Int) {
        if resolutionPositionActive != position {
            delegate.setResolutionSwitchState(resolutionPositionActive,
                                              state: false)
        }

        delegate.setResolutionSwitchState(position,
                                          state: true)
        resolutionPositionActive = position
    }

    func accepButtonEvent() {
        interactor?.setResolutionToDevice(resolutionPositionActive)
    }

    // MARK: - Delegate
    func setResolutionsTitle(_ titleList: [String]) {
        delegate.setResolutionsTableList(titleList)
    }

    func setActiveResolution(_ position: Int) {
        resolutionPositionActive = position

        delegate.setResolutionSwitchState(position,
                                          state: true)
    }

    func retrieveAVResolutionPresset(_ resolution: String) {
        delegate.sendAVResolutionPressetToThirdParty(resolution)
    }
}
