//
//  GetImageByTextUseCase.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 19/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit

public class GetImageByTextUseCase: NSObject {
    public func getTextImage(text: String,
                      attributes: CATextLayerAttributes) -> UIImage {

        let frame = CGRect(x: 0, y: 0, width: 1920, height: 1080)

        let parentLayer = CALayer()
        parentLayer.frame = frame

        let textLayer = CATextLayer()

        textLayer.string = text
        textLayer.font = attributes.font
        textLayer.fontSize = attributes.fontSize

        textLayer.alignmentMode = attributes.horizontalAlignment.rawValue
        textLayer.isWrapped = true
        textLayer.truncationMode = "middle"

        textLayer.frame = attributes.getFrameForString(frame: frame)

        parentLayer.addSublayer(textLayer)

        let image = UIImage.imageWithLayer(layer: parentLayer)

        return image
    }
}

extension UIImage {
    class func imageWithLayer(layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: 1920, height: 1080), layer.isOpaque, 0.0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
