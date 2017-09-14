//
//  VideoGalleryDelegateInterface.swift
//  VideoGallery
//
//  Created by Alejandro Arjonilla Garcia on 3/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import Photos

public protocol VideoGalleryDelegate {
    func cancelPushed()
    func saveVideos(_ URLs: [URL])
}
