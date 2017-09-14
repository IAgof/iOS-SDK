//
//  VideonaRangeSliderTrackLayer.swift
//  VideonaRangeSlider
//
//  Created by Alejandro Arjonilla Garcia on 14/11/16.
//  Copyright © 2016 videona. All rights reserved.
//

import Foundation

class VideonaRangeSliderTrackLayer: CAShapeLayer {

    weak var rangeSlider: VideonaRangeSlider?
    var height: CGFloat?

    override func draw(in ctx: CGContext) {
        if let slider = rangeSlider {
            var trackedAreaHeight = bounds.height
            if height != nil {
                trackedAreaHeight = height!
            }
            guard let rangeSliderHeight = rangeSlider?.frame.height else {
                print("no range slider height")
                return
            }

            trackedAreaHeight = min(trackedAreaHeight, rangeSliderHeight)
            let heightCenter = (self.frame.height - trackedAreaHeight)  / 2

            let lowerValuePosition = CGFloat(slider.positionForValue(slider.lowerValue))
            let upperValuePosition = CGFloat(slider.positionForValue(slider.upperValue))
            let rect = CGRect(x: lowerValuePosition,
                              y: heightCenter,
                              width: upperValuePosition - lowerValuePosition,
                              height: trackedAreaHeight)

            ctx.setFillColor(slider.sliderTintColor.cgColor)
            ctx.fill(rect)
        }
    }
}
