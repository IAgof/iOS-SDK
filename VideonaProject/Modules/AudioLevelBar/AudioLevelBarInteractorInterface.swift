//
//  AudioLevelBarInteractorInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

protocol AudioLevelBarInteractorInterface {
    func startToGetAudioLevel()
}

protocol AudioLevelBarInteractorDelegate {
    func setAudioLevel(_ value: Float)
}
