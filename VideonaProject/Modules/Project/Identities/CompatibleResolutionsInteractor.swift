//
//  CompatibleResolutionsInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 9/6/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation

public class CompatibleResolutionsInteractor: NSObject {

    public func getCompatibleResolutions() -> Array<String> {
        var compatibleResolutions = Array<String>()

        if #available(iOS 9.0, *) {
            compatibleResolutions.append(AVCaptureSessionPreset3840x2160)
        }
        compatibleResolutions.append(AVCaptureSessionPreset1920x1080)
        compatibleResolutions.append(AVCaptureSessionPreset1280x720)

        return compatibleResolutions
    }
}
