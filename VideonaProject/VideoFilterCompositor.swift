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
                guard let track = getTrack(time: request.compositionTime, tracks: instruction.tracks) else{return}
                let trackID = track.trackID
                guard let pixels = request.sourceFrame(byTrackID: trackID) else{
                    request.finish(with: NSError(domain: "jojodmo.com", code: 761, userInfo: nil))
                    return
                }
                
                var image = CIImage(cvPixelBuffer: pixels)
                for filter in instruction.filters{
                  filter.setValue(image, forKey: kCIInputImageKey)
                  image = filter.outputImage ?? image
                }
                
                image = addTransitionIfIsInTime(image: image,
                                             tracks: instruction.tracks,
                                             actualTime:request.compositionTime,
                                             transitionColor:instruction.transitionColor,
                                             transitionTime: instruction.transitionTime)
                
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
    
    func addTransitionIfIsInTime(image:CIImage,
                              tracks:[AVAssetTrack],
                              actualTime:CMTime,
                              transitionColor:CIColor,
                              transitionTime:CMTime)->CIImage{
        guard let track = getTrack(time: actualTime, tracks: tracks) else{return CIImage()}
        let fadeInTimeRange = CMTimeRangeMake(getTrackStartTime(startTime: actualTime, tracks: tracks), transitionTime)
        let startFadeOutTime = CMTimeSubtract(track.timeRange.end, transitionTime)
        let fadeOutTimeRange = CMTimeRangeMake(startFadeOutTime, transitionTime)
        
        if fadeInTimeRange.containsTime(actualTime){
            let alpha = 1 - (actualTime.seconds - fadeInTimeRange.start.seconds)
            
            let color = CIColor(red: transitionColor.red,
                                green: transitionColor.green,
                                blue: transitionColor.blue,
                                alpha:CGFloat(alpha))
            
            let blendColorImage = CIImage(color: color)
            let transitionFilter = CIFilter(name: "CISourceAtopCompositing")!
            transitionFilter.setValue(blendColorImage, forKey: "inputImage")
            transitionFilter.setValue(image, forKey: "inputBackgroundImage")
            return transitionFilter.outputImage!
        }
        
        if fadeOutTimeRange.containsTime(actualTime){
            let alpha = (actualTime.seconds - fadeOutTimeRange.start.seconds)

            let color = CIColor(red: transitionColor.red,
                                green: transitionColor.green,
                                blue: transitionColor.blue,
                                alpha:CGFloat(alpha))
            
            let blendColorImage = CIImage(color: color)
            let transitionFilter = CIFilter(name: "CISourceAtopCompositing")!
            transitionFilter.setValue(blendColorImage, forKey: "inputImage")
            transitionFilter.setValue(image, forKey: "inputBackgroundImage")
            return transitionFilter.outputImage!
        }
        
        return image
    }
    
    func getTrack(time:CMTime,tracks:[AVAssetTrack]) -> AVAssetTrack? {
        for track in tracks {
            if track.timeRange.containsTime(time){
                return track
            }
        }
        return nil
    }
    
    func getTrackStartTime(startTime:CMTime,tracks:[AVAssetTrack]) -> CMTime{
        var endTime = kCMTimeZero
        for track in tracks {
            if track.timeRange.containsTime(startTime){
                return endTime
            }
            endTime = track.timeRange.end
        }
        return endTime
    }
    func renderContextChanged(_ newRenderContext: AVVideoCompositionRenderContext){
        self.renderContextQueue.sync{
            self.renderContext = newRenderContext
        }
    }
}
