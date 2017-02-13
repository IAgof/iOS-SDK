//
//  SplitPresenterInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 4/8/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation

public protocol SplitPresenterInterface{
    func viewDidLoad()
    func viewWillDissappear()
    func pushCancelHandler()
    func pushAcceptHandler()
    func pushBack()
    func setSplitValue(_ value:Float)
    func updateSplitValueByPlayer(_ value:Float)
    func expandPlayer()
}

public protocol SplitPresenterDelegate {
    func configureRangeSlider(_ splitValue: Float,
                              maximumValue:Float)
    func setSliderValue(_ value:Float)
    func bringToFrontExpandPlayerButton()
    
    func acceptFinished()
    func pushBackFinished()
    func expandPlayerToView()
    func setStopToVideo()
    func updatePlayerOnView(_ composition:VideoComposition)
    func setPlayerToSeekTime(_ time:Float)
}
