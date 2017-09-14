//
//  VideoGalleryInterface.swift
//  VideosGallery
//
//  Created by Alejandro Arjonilla Garcia on 2/11/16.
//  Copyright © 2016 ArjonillaCorporation. All rights reserved.
//

import Foundation
import Photos

public protocol VideoGalleryInterface {
    var albumName: String {get set}
    func getVideosSelectedURL(_ completion: @escaping ([URL]) -> Void)
}
