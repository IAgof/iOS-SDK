//
//  ExposurePresenter.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

open class ExposurePresenter: ExposurePresenterInterface, ExposureInteractorDelegate {
    //MARK : VIPER
    var delegate: ExposurePresenterDelegate
    var interactor: ExposureInteractorInterface?

    init(controller: ExposureView) {
        delegate = controller
        interactor = ExposureInteractor(presenter: self)
    }

    // MARK: Interface
    func exposureValueChanged(_ value: Float) {
        interactor?.setExposureToDevice(value)
    }

    // MARK: Interactor Delegate

}
