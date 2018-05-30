//
//  InputSoundGainControlInteractorInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

protocol InputSoundGainControlInteractorInterface {
	var isInputGainSettable: Bool {get}
    func setInputGainLevel(_ value: Float)
}

protocol InputSoundGainControlInteractorDelegate {
}
