//
// Created by Alejandro Arjonilla Garcia on 15/6/16.
// Copyright (c) 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation

public class CompatibleQualityInteractor: NSObject {

    public func getCompatibleQuality() -> Array<String> {
        var compatibleQuality = Array<String>()

        compatibleQuality.append(AVAssetExportPresetHighestQuality)
        compatibleQuality.append(AVAssetExportPresetMediumQuality)
        compatibleQuality.append(AVAssetExportPresetLowQuality)

        return compatibleQuality
    }
}
