//
//  TrimPresenter.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 1/8/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

open class TrimPresenter: NSObject,
    TrimPresenterInterface,
TrimInteractorDelegate {
    //MARK: - Variables VIPER
    open var delegate:TrimPresenterDelegate?
    open var interactor: TrimInteractorInterface?
    
    //MARK: - Variables
    var videoSelectedIndex:Int!{
        didSet{
            interactor?.setVideoPosition(videoSelectedIndex)
        }
    }
    
    var isGoingToExpandPlayer = false

    var lowerValueOld:Float! = -1.0
    var lowerValue:Float!{
        didSet{
            if lowerValue != nil {                
                let text = Utils().hourToString(Double(lowerValue))
                delegate?.setMinRangeValue(text)
                if upperValue != nil{
                    updateRangeVal()
                    if lowerValue != lowerValueOld {
                        lowerValueOld = lowerValue
                        self.seekToTimeInPlayer(lowerValue)
                    }
                }
            }
        }
    }
    
    var upperValueOld:Float! = -1.0
    var upperValue:Float!{
        didSet{
            if  upperValue != nil {
                let text = Utils().hourToString(Double(upperValue))
                delegate?.setMaxRangeValue(text)
                if  lowerValue != nil{
                    updateRangeVal()
                    if upperValue != upperValueOld {
                        upperValueOld = upperValue
                        self.seekToTimeInPlayer(upperValue)
                    }
                }
            }
        }
    }
    var maximumValue:Float!
    
    var rangeVal:Float! = 0.0{
        didSet{
            let text = Utils().hourToString(Double(rangeVal))
            delegate?.setRangeValue(text)
        }
    }

    open func updateRangeVal(){
        rangeVal = upperValue - lowerValue
    }
    
    open func seekToTimeInPlayer(_ time:Float){
        if maximumValue != nil {
            delegate?.setPlayerToSeekTime(time)
        }
    }
    
    open func updateVideoParams(){
        interactor?.setParametersOnVideoSelected(lowerValue,
                                                 stopTime: upperValue)
        updatePlayer()
    }
    
    //MARK: - Interface
    open func viewDidLoad() {
        delegate?.bringToFrontExpandPlayerButton()

        interactor?.getVideoParams()
    }
    
    open func viewWillDissappear() {
        if !isGoingToExpandPlayer{
            upperValue = nil
            lowerValue = nil
            
            delegate?.setStopToVideo()
        }
    }
    
    open func pushAcceptHandler() {
        interactor?.setParametersOnVideoSelectedOnProjectList(lowerValue,
                                                              stopTime: upperValue)
        delegate?.acceptFinished()
    }
    
    open func pushCancelHandler() {
        delegate?.pushBackFinished()
    }
    
    open func pushBack() {
        delegate?.pushBackFinished()
    }
    
    open func expandPlayer() {
        isGoingToExpandPlayer = true
        
        delegate?.expandPlayerToView()
    }
    
    open func trimSliderEnded() {
        updateVideoParams()
    }
    
    open func trimSliderBegan() {
        interactor?.setParametersOnVideoSelected(0,
                                                 stopTime: maximumValue)
        updatePlayer()
    }
    
    open func getVideoSelectedIndex() -> Int {
        return videoSelectedIndex
    }
    
    open func setVideoSelectedIndex(_ index: Int) {
        videoSelectedIndex = index
    }
    
    //MARK: - interactor delegate
    open func setLowerValue(_ value: Float) {
        self.lowerValue = value
    }
    
    open func setUpperValue(_ value: Float) {
        self.upperValue = value
    }
    
    open func setMaximumValue(_ value: Float) {
        self.maximumValue = value
    }
    
    open func updateParamsFinished() {
        updateVideoParams()        
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate?.configureRangeSlider(self.lowerValue,
                upperValue: self.upperValue,
                maximumValue: self.maximumValue )
        })
    }
    
    
    //MARK: - Inner public functions
    open func updatePlayer(){
        interactor?.setUpComposition({composition in
            self.delegate?.updatePlayerOnView(composition)
        })
    }
    
    open func setTrimLeftDecreaseTime() {
        
    }
    
    open func setTrimLeftIncreaseTime() {
        
    }
    
    open func setTrimRightDecreaseTime() {
        
    }
    
    open func setTrimRightIncreaseTime() {
        
    }

    open func setMilisecondsLow() {
        
    }
    
    open func setMilisecondsMedium() {
        
    }
    
    open func setMilisecondsHigh() {
        
    }
}
