//
//  String+Extensions.swift
//  VideonaProject
//
//  Created by Alejandro Arjonilla Garcia on 21/10/17.
//  Copyright © 2017 videona. All rights reserved.
//

import Foundation

extension String {
    public var watermarkImage: CGImage?{
        switch self {
        case "AVCaptureSessionPreset1280x720": return #imageLiteral(resourceName: "watermark_720").cgImage
        case "AVCaptureSessionPreset1920x1050": return #imageLiteral(resourceName: "watermark_1080").cgImage
        case "AVCaptureSessionPreset3840x2160": return #imageLiteral(resourceName: "watermark_4k").cgImage
        default: return #imageLiteral(resourceName: "watermark_1080").cgImage
        }
    }
}
