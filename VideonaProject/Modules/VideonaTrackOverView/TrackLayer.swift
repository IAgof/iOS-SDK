//
//  TrackLayer.swift
//  testDrawingPortionsOverVideonaRangeSlider
//
//  Created by Alejandro Arjonilla Garcia on 3/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import UIKit

public class TrackLayer: CALayer {
    var trackValues: TrackModel?

    override public func layoutSublayers() {
        guard let track = trackValues else {
            return
        }
        super.layoutSublayers()
        let height = self.frame.height

        self.frame = CGRect(x: track.lowerValue * self.frame.width,
                            y: 0,
                            width: track.width * self.frame.width,
                            height: height)

        self.backgroundColor = track.color

        self.setNeedsDisplay()
    }

    override public func draw(in ctx: CGContext) {
            ctx.strokePath()
    }
}
