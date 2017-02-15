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

class VideoFilterCompositionInstruction : AVMutableVideoCompositionInstruction{
    
   // For implementation in Swift 2.x, look at the history of this file at
   // https://github.com/jojodmo/VideoFilterExporter/blob/1d506238a445b6684ef40d2701419cc01158331e/VideoFilterCompositionInstruction.swift
   
    let filters: [CIFilter]
    let context: CIContext
    let tracks:[AVAssetTrack]
    let transitionColor:CIColor
    
    override var containsTweening: Bool{get{return false}}
    
    init(tracks:[AVAssetTrack] , filters: [CIFilter], context: CIContext,transitionColor color:CIColor){
        self.tracks = tracks
        self.filters = filters
        self.context = context
        self.transitionColor = color
        
        super.init()
        
        self.enablePostProcessing = true
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
}
