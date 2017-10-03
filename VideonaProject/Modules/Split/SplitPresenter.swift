//
//  SplitPresenter.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 4/8/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

open class SplitPresenter: NSObject, SplitPresenterInterface, SplitInteractorDelegate {
    // MARK: - Variables VIPER
    open var delegate: SplitPresenterDelegate?
    open var interactor: SplitInteractorInterface?

    // MARK: - Variables
    open var videoSelectedIndex: Int! {
        didSet {
            interactor?.setVideoPosition(videoSelectedIndex)
        }
    }

    open var isMovingByPlayer = false
    open var isGoingToExpandPlayer = false
    var isFirstLoad = true
    var maximumValue: Float!

    var splitValue: Float! {
        didSet {
            if splitValue != nil {
                if maximumValue != nil {
                    setValuesOnFirstLoad()
                    if isMovingByPlayer {
                        delegate?.setSliderValue(splitValue)
                    } else {
                        self.delegate?.setPlayerToSeekTime(splitValue)
                        self.isMovingByPlayer = false
                    }
                }
            }
        }
    }

    func setValuesOnFirstLoad() {
        if isFirstLoad {
            Utils().delay(0.3, closure: {
                DispatchQueue.main.async(execute: { () -> Void in
                    self.delegate?.setSliderValue(self.splitValue)
                    self.delegate?.setPlayerToSeekTime(self.splitValue)
                })
            })
            isFirstLoad = false
        }
    }

    // MARK: - Interface
    open func viewDidLoad() {

        delegate?.bringToFrontExpandPlayerButton()

        interactor?.getVideoParams()

        delegate?.configureRangeSlider(splitValue,
                                         maximumValue: maximumValue)

        self.delegate?.setPlayerToSeekTime(self.splitValue)

        self.delegate?.setSliderValue(splitValue)

        interactor?.setUpComposition({composition in
                                        self.delegate?.updatePlayerOnView(composition)
        })
    }
	
	open func viewDidLayoutSubviews(_ value: CGFloat) {
		DispatchQueue.main.async(execute: {
			self.delegate?.updateSplitRangeSliderDiameter(value)
		})
	}

    open func viewWillDissappear() {
        if !isGoingToExpandPlayer {
            delegate?.setStopToVideo()
        }
        isFirstLoad = true
    }

    open func pushAcceptHandler() {
        interactor?.setSplitVideosToProject(Double(splitValue))
        delegate?.acceptFinished()
    }

    open func pushCancelHandler() {
        delegate?.pushBackFinished()
    }
    open func pushBack() {
        delegate?.pushBackFinished()
    }

    open func setSplitValue(_ value: Float) {
        isMovingByPlayer = false
        self.splitValue = value
    }

    open func updateSplitValueByPlayer(_ value: Float) {
        isMovingByPlayer = true
        self.splitValue = value
    }

    open func expandPlayer() {
        delegate?.expandPlayerToView()

        isGoingToExpandPlayer = true
    }

    // MARK: Interactor Delegate
    open func settSplitValue(_ value: Float) {
        splitValue = value
    }

    open func setMaximumValue(_ value: Float) {
        maximumValue = value
    }

    func calculateSplitAccurateLeftValue (_ value: Float) -> Float {
        let valueUpdated = splitValue + value
        return valueUpdated < 0 ? 0 : valueUpdated
    }

    func calculateSplitAccurateRightValue (_ value: Float) -> Float {
        let valueUpdated = splitValue + value
        return valueUpdated > maximumValue ? maximumValue : valueUpdated
    }

    open func setSplitAccurateLeftLowValue() {
        splitValue = calculateSplitAccurateLeftValue(-0.3)
        delegate?.setSliderValue(splitValue)
    }

    open func setSplitAccurateLeftMediumValue() {
        splitValue = calculateSplitAccurateLeftValue(-0.6)
        delegate?.setSliderValue(splitValue)
    }

    open func setSplitAccurateLeftHighValue() {
        splitValue = calculateSplitAccurateLeftValue(-1.2)
        delegate?.setSliderValue(splitValue)
    }

    open func setSplitAccurateRightLowValue() {
        splitValue = calculateSplitAccurateRightValue(0.3)
        delegate?.setSliderValue(splitValue)
    }

    open func setSplitAccurateRightMediumValue() {
        splitValue = calculateSplitAccurateRightValue(0.6)
        delegate?.setSliderValue(splitValue)
    }

    open func setSplitAccurateRightHighValue() {
        splitValue = calculateSplitAccurateRightValue(1.2)
        delegate?.setSliderValue(splitValue)
    }

}
