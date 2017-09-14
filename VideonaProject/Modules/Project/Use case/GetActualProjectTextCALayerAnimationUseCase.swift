//
//  GetActualProjectCALayerAnimationUseCase.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 20/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

public class GetActualProjectCALayerAnimationUseCase: NSObject {
    typealias orderType = () -> ([Double])
    var videonaComposition: VideoComposition
    static let numberPasos: Int = 100

    let ascend: orderType = {
        var newTimes: [Double] = []
        for i in 0...numberPasos { newTimes.append(Double(i)/Double(numberPasos)) }
        newTimes.removeLast()
        newTimes.append(0)

        return newTimes
    }

    let descend: orderType = {
        var newTimes: [Double] = []
        for i in 0...numberPasos { newTimes.append(Double(numberPasos - i)/Double(numberPasos)) }
        return newTimes
    }

    var keyTimes: [NSNumber] {
        var newTimes: [NSNumber] = []
        let numberPasos = GetActualProjectCALayerAnimationUseCase.numberPasos
        for i in 0...numberPasos { newTimes.append(NSNumber(value: Double(i)/Double(numberPasos))) }
        return newTimes
    }

    let layer: (UIImage) -> (CALayer) = { image in
        let imageLayer = CALayer()
        imageLayer.contents = image.cgImage
        imageLayer.frame = CGRect(x: 0.0, y: 0.0,
                                  width: image.size.width, height: image.size.height)
        imageLayer.contentsScale = UIScreen.main.scale
        imageLayer.opacity = 0.0
        return imageLayer
    }

    public init(videonaComposition: VideoComposition) {
        self.videonaComposition = videonaComposition
    }

    func getKeyValues(isFadeIn: Bool) -> ([Double]) {
        return isFadeIn ? descend() : ascend()
    }

    public func getCALayerAnimation(project: Project) -> CALayer {
        let videos = project.getVideoList()

        var layers: [CALayer] = getTextLayersAnimated(videoList: videos)
        let parentLayer = CALayer()

        for fadeInTimeRange in videonaComposition.fadeInTransitionTimeRanges {
            if fadeInTimeRange.duration.seconds > 0 { layers.append(getTransitionLayer(timeStart: fadeInTimeRange.start.seconds, isFadeIn: true, duration: fadeInTimeRange.duration.seconds))}
        }

        for fadeOutTimeRange in videonaComposition.fadeOutTransitionTimeRanges {
            if fadeOutTimeRange.duration.seconds > 0 { layers.append(getTransitionLayer(timeStart: fadeOutTimeRange.start.seconds, isFadeIn: false, duration: fadeOutTimeRange.duration.seconds))}
        }

        for layer in layers {
            parentLayer.addSublayer(layer)
        }

        if project.hasWatermark {
            let watermarkLayer = getWatermarkLayersAnimated()
            parentLayer.addSublayer(watermarkLayer)
        }

        return parentLayer
    }

    public func getTransitionLayer(timeStart: Double, isFadeIn: Bool, duration: Double) -> CALayer {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: 1920, height: 1080)
        layer.opacity = 0
        layer.backgroundColor = UIColor.white.cgColor

        //TODO: This code is repeated
        let animation = CAKeyframeAnimation(keyPath:"opacity")
        animation.beginTime = AVCoreAnimationBeginTimeAtZero + timeStart
        animation.duration = duration
        animation.keyTimes = keyTimes
        animation.values = getKeyValues(isFadeIn: isFadeIn)
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        layer.add(animation, forKey:"animateOpacity")

        return layer
    }

    public func getWatermarkLayersAnimated() -> CALayer {
        let watermarkLayer = CALayer()

        watermarkLayer.frame = CGRect(x: 0, y: 0, width: 1920, height: 1080)

        guard let duration = videonaComposition.mutableComposition?.duration.seconds else { return watermarkLayer }

        addAnimationToLayer(overlay: watermarkLayer,
                            timeAt: 0.0,
                            duration: duration)

        guard let image = UIImage(named: "watermark")?.cgImage else { return watermarkLayer }
        watermarkLayer.contents = image

        return watermarkLayer
    }

    public func getTextLayersAnimated(videoList: [Video], outputSize: CGSize? = nil) -> [CALayer] {
        var layers: [CALayer] = []

        var timeToInsertAnimate = 0.0

        for video in videoList {
            guard let textPosition =  CATextLayerAttributes.VerticalAlignment(rawValue: video.textPositionToVideo) else {
                print("Not valid position")
                return []}

            if video.textToVideo != "" {
                let textImage = GetImageByTextUseCase().getTextImage(text: video.textToVideo,
                                                                 attributes:CATextLayerAttributes().getAlignmentAttributesByType(type: textPosition))
                let textImageLayer = layer(textImage)
                if let outputSize = outputSize { textImageLayer.frame = CGRect(origin: CGPoint.zero, size: outputSize)}
                addAnimationToLayer(overlay: textImageLayer,
                                    timeAt: timeToInsertAnimate,
                                    duration: video.getDuration())

                layers.append(textImageLayer)
                timeToInsertAnimate += video.getDuration()
            }
        }

        return layers
    }

   public func addAnimationToLayer(overlay: CALayer,
                             timeAt: Double,
                             duration: Double) {
        //Animacion de entrada
        let animationEntrada = CAKeyframeAnimation(keyPath:"opacity")
        animationEntrada.beginTime = AVCoreAnimationBeginTimeAtZero + timeAt
        animationEntrada.duration = duration
        animationEntrada.keyTimes = [0.0, 0.01, 0.99, 1.0]
        animationEntrada.values = [0.0, 1.0, 1.0, 0.0]
        animationEntrada.isRemovedOnCompletion = false
        animationEntrada.fillMode = kCAFillModeForwards
        overlay.add(animationEntrada, forKey:"animateOpacity")
    }
}
