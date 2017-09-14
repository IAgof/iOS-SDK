//
//  ExpositionModesPresenter.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

open class ExpositionModesPresenter: ExpositionModesPresenterInterface {
    //MARK : VIPER
    var delegate: ExpositionModesPresenterDelegate
    var interactor: ExpositionModesInteractorInterface?

    var manualSliderIsShowing = false

    init(controller: ExpositionModesView) {
        delegate = controller
        interactor = ExpositionModesInteractor(presenter: self)
    }

    func autoModePushed() {
        interactor?.setAutoExposureMode()

        hideManualSliderIfYouCan()

        setAllButtonsUnSelected()
        delegate.setAutoButtonSelected(true)
    }

    func manualSliderPushed() {
        if manualSliderIsShowing {
            hideManualSliderIfYouCan()
        } else {
            delegate.showExpositionSlider()

            interactor?.setManualExposureModeOff()
            setAllButtonsUnSelected()
            delegate.setSliderManualButtonSelected(true)

            manualSliderIsShowing = true
        }
    }

    func centerModePushed() {
        interactor?.setExpositionCenterMode()
        hideManualSliderIfYouCan()

        setAllButtonsUnSelected()
        delegate.setCenterButtonSelected(true)
    }

    func manualModePushed() {
        interactor?.setManualExposureMode()
        hideManualSliderIfYouCan()

        setAllButtonsUnSelected()
        delegate.setManualButtonSelected(true)
    }

    func hideManualSliderIfYouCan() {
        if manualSliderIsShowing {
            delegate.hideExpositionSlider()

            manualSliderIsShowing = false
        }
    }

    func checkIfHadToShowSlider() {
        if manualSliderIsShowing {
            delegate.showExpositionSlider()
        }
    }

    func setAllButtonsUnSelected() {
        delegate.setAutoButtonSelected(false)
        delegate.setCenterButtonSelected(false)
        delegate.setManualButtonSelected(false)
        delegate.setSliderManualButtonSelected(false)
    }

    func setFocusAtPoint(_ point: CGPoint, frame: CGRect) {
        interactor?.expositionToPoint(point,
                                      viewFrame: frame)
    }
}
extension ExpositionModesPresenter:ExpositionModesInteractorDelegate {
    func sendFocusPoint(_ point: CGPoint) {
        delegate.sendFocusPoint(point)
    }
}
