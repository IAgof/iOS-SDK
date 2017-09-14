//
//  VideonaRangeSliderThumbLayer.swift
//  VideonaRangeSlider
//
//  Created by Alejandro Arjonilla Garcia on 14/11/16.
//  Copyright © 2016 videona. All rights reserved.
//

import Foundation

class VideonaRangeSliderThumbLayer: CALayer {
    var highlighted = false
    weak var rangeSlider: VideonaRangeSlider?
    var image: UIImage?

    override func layoutSublayers() {
        super.layoutSublayers()

        guard let height = rangeSlider?.frame.height else {
            print("no range slider height")
            return
        }

        self.cornerRadius = self.bounds.width / 2
        self.frame = CGRect(x: self.frame.origin.x,
                                y: (height-self.frame.height)/2,
                                width: self.frame.width,
                                height: self.frame.height)
        self.setNeedsDisplay()
    }

    override func draw(in ctx: CGContext) {
        if image == nil {
            ctx.strokePath()
        } else {
            ctx.drawFlipped(image: image!.cgImage!, rect: CGRect(x: 0, y: 0, width: image!.size.width, height: image!.size.height))

            self.backgroundColor = UIColor.clear.cgColor
        }
    }
}

extension CGContext {
    func drawFlipped(image: CGImage, rect: CGRect) {
        saveGState()
        translateBy(x: 0, y: rect.height)
        scaleBy(x: 1, y: -1)
        draw(image, in: rect)
        restoreGState()
    }
}
