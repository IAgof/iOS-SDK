//
//  VideonaRangeSliderDelegateProtocol.swift
//  VideonaRangeSlider
//
//  Created by Alejandro Arjonilla Garcia on 14/11/16.
//  Copyright © 2016 videona. All rights reserved.
//

public protocol VideonaRangeSliderDelegate {
    func rangeSliderLowerThumbValueChanged()
    func rangeSliderMiddleThumbValueChanged()
    func rangeSliderUpperThumbValueChanged()

    func rangeSliderLowerValueStartToChange()
    func rangeSliderUpperValueStartToChange()

    func rangeSliderLowerValueStopToChange()
    func rangeSliderUpperValueStopToChange()
}
