//
//  DuplicateInteractorInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 4/8/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation

public protocol DuplicateInteractorInterface {
    func setUpComposition(_ videoSelectedIndex: Int, completion: (VideoComposition) -> Void)
    func setVideoPosition(_ position: Int)
    func setDuplicateVideoToProject(_ numberDuplicates: Int)
    func getThumbnail(_ frame: CGRect)
}

public protocol DuplicateInteractorDelegate {
    func setThumbnail(_ image: UIImage)
    func duplicateActionFinished()
}
