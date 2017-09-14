//
//  ZoomSliderPresenter.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

open class ZoomSliderPresenter: ZoomSliderPresenterInterface, ZoomSliderInteractorDelegate {
    //MARK : VIPER
    var delegate: ZoomSliderPresenterDelegate
    var interactor: ZoomSliderInteractorInterface?

    init(controller: ZoomSliderView) {
        delegate = controller
        interactor = ZoomSliderInteractor(presenter: self)
    }

    func sliderValueHasChangedTo(_ value: Float) {
        interactor?.setZoomTo(value)
    }

    func setZoomWithPinch(_ scale: CGFloat,
                          velocity: CGFloat) {
        interactor?.setZoomTo(scale,
                              velocity: velocity)
    }

    // MARK: - Delegate
    func zoomPinchedValueUpdate(_ value: Float) {
        delegate.updateSliderValue(value)
    }
}
