//
//  PlayerItem.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 17/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

open class PlayerItem: NSObject {

    var movieURL: URL

    init(movieURL: URL) {
        self.movieURL = movieURL
    }

    open func setVideoURL(_ movieURL: URL) {
        self.movieURL = movieURL
    }

    open func getMovieURL() -> URL {
        return movieURL
    }
}
