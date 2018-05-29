//
//  InputSoundGainControlPresenter.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

open class InputSoundGainControlPresenter: InputSoundGainControlPresenterInterface, InputSoundGainControlInteractorDelegate {
    //MARK : VIPER
    var interactor: InputSoundGainControlInteractorInterface?

    init() {
        interactor = InputSoundGainControlInteractor(presenter: self)
    }

	func isInputGainSettable() -> Bool {
		guard let isSettable = interactor?.isInputGainSettable() else { return false }
		return isSettable
	}

    func sliderValueHasChangedTo(_ value: Float) {
        interactor?.setInputGainLevel(value)
    }
}
