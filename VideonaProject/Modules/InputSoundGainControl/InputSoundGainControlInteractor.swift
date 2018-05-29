//
//  InputSoundGainControlInteractor.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreAudio

class InputSoundGainControlInteractor: InputSoundGainControlInteractorInterface {

    //MARK : VIPER
    var delegate: InputSoundGainControlInteractorDelegate?

	let audioSession = AVAudioSession.sharedInstance()

    var maxZoomFactor = CGFloat(10)

    init(presenter: InputSoundGainControlPresenter) {
        delegate = presenter
    }

	func isInputGainSettable() -> Bool {
		return audioSession.isInputGainSettable
	}

    func setInputGainLevel(_ value: Float) {
        do {
            try audioSession.setInputGain(value)
        } catch _ as NSError {
//            print(e.localizedDescription, e.localizedFailureReason, e.localizedRecoveryOptions, e.localizedRecoverySuggestion)
        }
    }
}
