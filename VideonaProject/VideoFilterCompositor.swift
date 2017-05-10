/*
   Copyright 2016 Domenico Ottolia

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

import Foundation
import AVFoundation
import CoreImage

class VideoFilterCompositor : NSObject, AVVideoCompositing{
    
    // For Swift 2.*, replace [String : Any] and [String : Any]? with [String : AnyObject] and [String : AnyObject]? respectively
   
    // You may alter the value of kCVPixelBufferPixelFormatTypeKey to fit your needs
    var requiredPixelBufferAttributesForRenderContext: [String : Any] = [
        kCVPixelBufferPixelFormatTypeKey as String : NSNumber(value: kCVPixelFormatType_32BGRA as UInt32),
        kCVPixelBufferOpenGLESCompatibilityKey as String : NSNumber(value: true),
        kCVPixelBufferOpenGLCompatibilityKey as String : NSNumber(value: true)
    ]
    
    // You may alter the value of kCVPixelBufferPixelFormatTypeKey to fit your needs
    var sourcePixelBufferAttributes: [String : Any]? = [
        kCVPixelBufferPixelFormatTypeKey as String : NSNumber(value: kCVPixelFormatType_32BGRA as UInt32),
        kCVPixelBufferOpenGLESCompatibilityKey as String : NSNumber(value: true),
        kCVPixelBufferOpenGLCompatibilityKey as String : NSNumber(value: true)
    ]
    
    let renderQueue = DispatchQueue(label: "com.jojodmo.videofilterexporter.renderingqueue", attributes: [])
    let renderContextQueue = DispatchQueue(label: "com.jojodmo.videofilterexporter.rendercontextqueue", attributes: [])
    
    var renderContext: AVVideoCompositionRenderContext!
    override init(){
        super.init()
    }
    
    func startRequest(_ request: AVAsynchronousVideoCompositionRequest){
        autoreleasepool(){
            self.renderQueue.sync{
                guard let instruction = request.videoCompositionInstruction as? VideoFilterCompositionInstruction else{
                    request.finish(with: NSError(domain: "jojodmo.com", code: 760, userInfo: nil))
                    return
                }
                let trackID = instruction.track.trackID
                guard let pixels = request.sourceFrame(byTrackID: trackID) else{
//                    request.finish(with: NSError(domain: "jojodmo.com", code: 761, userInfo: nil))
                    request.finish(withComposedVideoFrame: self.renderContext.newPixelBuffer()!)
                    return
                }
                
                var image = CIImage(cvPixelBuffer: pixels)
                for filter in instruction.filters{
                  filter.setValue(image, forKey: kCIInputImageKey)
                  image = filter.outputImage ?? image
                }
                
                image = addTransitionIfIsInTime(image: image,
                                             actualTime:request.compositionTime,
                                             transitionColor:instruction.transitionColor,
                                             fadeInTimeRange: instruction.fadeInTransitionTimeRanges.first(where: { (timeRange) -> Bool in
                                                timeRange.containsTime(request.compositionTime)
                                             }),
                                             fadeOutTimeRange: instruction.fadeOutTransitionTimeRanges.first(where: { (timeRange) -> Bool in
                                                timeRange.containsTime(request.compositionTime)
                                             }))
                
                let newBuffer: CVPixelBuffer? = self.renderContext.newPixelBuffer()

                if let buffer = newBuffer{
                    instruction.context.render(image, to: buffer)
                    request.finish(withComposedVideoFrame: buffer)
                }
                else{
                    request.finish(withComposedVideoFrame: pixels)
                }
            }
        }
    }
    var fadeInStartTime: CMTime? = nil
    var fadeOutStartTime: CMTime? = nil
    
    func addTransitionIfIsInTime(image:CIImage,
                              actualTime:CMTime,
                              transitionColor:CIColor,
                              fadeInTimeRange:CMTimeRange?,
                              fadeOutTimeRange:CMTimeRange?)->CIImage{
     
        if let fadeInTimeRange = fadeInTimeRange, fadeInTimeRange.containsTime(actualTime){
            if fadeInStartTime == nil { fadeInStartTime = actualTime }
            let alpha = 1 - CMTimeSubtract(actualTime, fadeInStartTime!).seconds / fadeInTimeRange.duration.seconds
            print("Alpha fade in \(alpha)")
            let color = CIColor(red: transitionColor.red,
                                green: transitionColor.green,
                                blue: transitionColor.blue,
                                alpha:CGFloat(alpha))
            
            let blendColorImage = CIImage(color: color)
            let transitionFilter = CIFilter(name: "CISourceAtopCompositing")!
            transitionFilter.setValue(blendColorImage, forKey: "inputImage")
            transitionFilter.setValue(image, forKey: "inputBackgroundImage")
            return transitionFilter.outputImage!
        }else{ fadeInStartTime = nil}
        
        if let fadeOutTimeRange = fadeOutTimeRange, fadeOutTimeRange.containsTime(actualTime){
            if fadeOutStartTime == nil { fadeOutStartTime = actualTime }
            
            let alpha = CMTimeSubtract(actualTime, fadeOutStartTime!).seconds / fadeOutTimeRange.duration.seconds
            print("Alpha fade out \(alpha)")

            let color = CIColor(red: transitionColor.red,
                                green: transitionColor.green,
                                blue: transitionColor.blue,
                                alpha:CGFloat(alpha))
            
            let blendColorImage = CIImage(color: color)
            let transitionFilter = CIFilter(name: "CISourceAtopCompositing")!
            transitionFilter.setValue(blendColorImage, forKey: "inputImage")
            transitionFilter.setValue(image, forKey: "inputBackgroundImage")
            return transitionFilter.outputImage!
        }else{ fadeOutStartTime = nil}
        
        return image
    }
    
    func renderContextChanged(_ newRenderContext: AVVideoCompositionRenderContext){
        self.renderContextQueue.sync{
            self.renderContext = newRenderContext
        }
    }
}
