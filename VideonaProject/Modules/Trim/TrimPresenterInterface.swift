//
//  TrimPresenterInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 1/8/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation

public protocol TrimPresenterInterface {
    
    func viewDidLoad()
    func viewWillDissappear()
    func pushCancelHandler()
    func pushAcceptHandler()
    func pushBack()
    func expandPlayer()

    func setLowerValue(_ value:Float)
    func setUpperValue(_ value:Float)
    func trimSliderEnded()
    func trimSliderBegan()
    func getVideoSelectedIndex()->Int
    func setVideoSelectedIndex(_ index:Int)
    
    func setTrimLeftDecreaseTime()
    func setTrimLeftIncreaseTime()
    func setTrimRightDecreaseTime()
    func setTrimRightIncreaseTime()
    func setMilisecondsLow()
    func setMilisecondsMedium()
    func setMilisecondsHigh()
}

public protocol TrimPresenterDelegate {
    func setMinRangeValue(_ text:String)
    func setMaxRangeValue(_ text:String)
    func setRangeValue(_ text:String)
    func setTitleTrimLabel(_ text:String)
    func configureRangeSlider(_ lowerValue: Float,
                              upperValue: Float,
                              maximumValue:Float)
    func bringToFrontExpandPlayerButton()
    
    func acceptFinished()
    func pushBackFinished()
    func expandPlayerToView()
    func setPlayerToSeekTime(_ time:Float)
    func setStopToVideo()
    func updatePlayerOnView(_ composition:VideoComposition)
    func milisecondsLowSelect()
    func milisecondsLowUnselect()
    func milisecondsMediumSelect()
    func milisecondsMediumUnselect()
    func milisecondsHighSelect()
    func milisecondsHighUnselect()
	func swapImageLow()
	func swapImageMedium()
	func swapImageHigh()
}
