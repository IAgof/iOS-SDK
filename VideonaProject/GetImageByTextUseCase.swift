//
//  GetImageByTextUseCase.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 19/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

public class GetImageByTextUseCase:NSObject{
    public func getTextImage(text:String,
                      attributes:CATextLayerAttributes)->UIImage{
        
        let frame = CGRectMake(0, 0, 1920, 1080)
        
        let parentLayer = CALayer()
        parentLayer.frame = frame
        
        let textLayer = CATextLayer()
        var originalString: String = text
        let myString: NSString = originalString as NSString
        let size: CGSize = myString.sizeWithAttributes([NSFontAttributeName: attributes.font])
        
        textLayer.string = text
        textLayer.font = attributes.font
        textLayer.fontSize = attributes.fontSize
        
        textLayer.alignmentMode = attributes.horizontalAlignment.rawValue
        textLayer.wrapped = true
        textLayer.truncationMode = "middle"
        
        textLayer.frame = attributes.getFrameForString(frame)
        
        parentLayer.addSublayer(textLayer)
        
        let image = UIImage.imageWithLayer(parentLayer)
        
        return image
    }
}

extension UIImage {
    class func imageWithLayer(layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: 1920, height: 1080), layer.opaque, 0.0)
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}