//
//  PlayerProvider.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 17/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

open class PlayerProvider: NSObject {

    open func getMovieList()->Array<URL> {
        var movieList = Array<URL>()

        let path = Bundle.main.path(forResource: "video", ofType:"m4v")

        movieList.append(URL(fileURLWithPath: path!))

        return movieList
    }

    open func getTestVideo() -> URL {
      let path = Bundle.main.path(forResource: "video", ofType:"mp4")

        if let pathAux = path {
            return URL(fileURLWithPath: pathAux)

        } else {
            return URL(fileURLWithPath: "", isDirectory: false)
        }
    }
}
