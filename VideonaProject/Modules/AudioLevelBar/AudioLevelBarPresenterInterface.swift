//
//  AudioLevelBarPresenterInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

protocol AudioLevelBarPresenterInterface{
    func getAudioLevel()
}

protocol AudioLevelBarPresenterDelegate{
    func setAudioLevelToView(_ value:Float)
}
